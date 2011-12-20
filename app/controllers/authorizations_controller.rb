#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.


require 'jwt'
require File.join(Rails.root, "app", "models", "oauth2_provider_models_activerecord_authorization")
require File.join(Rails.root, "app", "models", "oauth2_provider_models_activerecord_client")

class AuthorizationsController < ApplicationController
  include OAuth2::Provider::Rack::AuthorizationCodesSupport
  
  before_filter :authenticate_user!, :except => [:token, :register]
  before_filter :redirect_or_block_invalid_authorization_code_requests,
                :only => [:new, :create]

  skip_before_filter :verify_authenticity_token, :only => :token

  def new
    if params[:uid].present? && params[:uid] != current_user.username
      sign_out current_user
      redirect_to url_with_prefilled_session_form
    else
      @client = oauth2_authorization_request.client
      
      if params[:response_type] == "code"
        if authorization = current_user.authorizations.where(:client_id => @client.id).first
          ac = authorization.authorization_codes.create(:redirect_uri => params[:redirect_uri])
          redirect_uri = Addressable::URI.parse(params[:redirect_uri])
          query_values = redirect_uri.query_values
          query_values ||= Hash.new
          redirect_uri.query_values = query_values.merge(:code => ac.code)
          redirect_to redirect_uri.to_s
          return
        end
      end
    end
  end

  # When diaspora detects that a user is trying to authorize to an application
  # as someone other than the logged in user, we want to log out current_user,
  # and prefill the session form with the user that is trying to authorize
  def url_with_prefilled_session_form
    redirect_url = Addressable::URI.parse(request.url)
    query_values = redirect_url.query_values
    query_values.delete("uid")
    query_values.merge!("username" => params[:uid])
    redirect_url.query_values = query_values
    redirect_url.to_s
  end

  def create
    if params[:commit] == "Authorize"
      grant_authorization_code(current_user, 5.years.from_now)
    else
      deny_authorization_code
    end
  end

  def register
    if params[:type] && params[:type] != 'client_associate'
      render :nothing => true, :status => 400
      return
    end
    
    if params[:signature] && params[:signed_string]
      signed_string = Base64.decode64(params[:signed_string])
      app_url = signed_string.split(';')[0].chomp("/")
      manifest_url = "#{app_url}/manifest.json"
      flow = "webapp"
    elsif params[:username] && params[:password] && params[:manifest] && params[:redirect_uri]
      user = User.where(:username => params[:username]).first
      if user && user.valid_password?(params[:password])
        sign_in user
        manifest_url = params[:manifest]
        flow = "mobile"
      else
        render :nothing => true, :status => 403
        return
      end
    else
      render :nothing => true, :status => 400
      return
    end

    begin
      packaged_manifest = JSON.parse(RestClient.get(manifest_url).body)
      public_key = OpenSSL::PKey::RSA.new(packaged_manifest['public_key'])
      manifest = JWT.decode(packaged_manifest['jwt'], public_key)
    rescue Exception => e
      debugger
      render :text => e.message, :status => 403
      return
    end
    
    if flow == "webapp"
      message = verify(signed_string, Base64.decode64(params[:signature]), public_key, manifest)
      unless message == "ok"
        render :text => message, :status => 400
        return
      end
    end
    
    client = OAuth2::Provider.client_class.find_or_create_from_manifest!(manifest, public_key)
    
    if flow == "webapp"
      render :json => {
        :client_id => client.oauth_identifier,
        :client_secret => client.oauth_secret
      }
    elsif flow == "mobile"
      redirect_to oauth_authorize_path(
        :redirect_uri => params[:redirect_uri],
        :uid => params[:username],
        :response_type => "code",
        :client_id => client.oauth_identifier
      )
    end
  end

  def token
    token = false
    if params[:code]
      block_invalid_authorization_code_requests
      
      token = oauth2_authorization_request.client.authorization_codes.claim(
        params[:code],
        params[:redirect_uri]
      )
      token ||= oauth2_authorization_request.client.authorization_codes.claim(
        params[:code],
        CGI.unescape(params[:redirect_uri])
      )
    elsif params[:refresh_token] && params[:client_id] && client = OAuth2::Provider.client_class.where(:oauth_identifier => params[:client_id]).first
      token = client.access_tokens.refresh_with(params[:refresh_token])
    else
      render :nothing => true, :status => 400
      return
    end
    
    if token
      render :json => {
        :access_token => token.access_token,
        :refresh_token => token.refresh_token,
        :expires_in => token.expires_in
      }
    else
      render :nothing => true, :status => 403
    end
  end

  def index
    @authorizations = current_user.authorizations
    @applications = current_user.applications
  end

  def destroy
    ## ID is actually the id of the client
    auth = current_user.authorizations.where(:client_id => params[:id]).first
    auth.revoke
    redirect_to authorizations_path
  end

  # @param [String] enc_signed_string A Base64 encoded string with app_url;pod_url;time;nonce
  # @param [String] sig A Base64 encoded signature of the decoded signed_string with public_key.
  # @param [OpenSSL::PKey::RSA] public_key The application's public key to verify sig with.
  # @return [String] 'ok' or an error message.
  def verify( signed_string, sig, public_key, manifest)
    split = signed_string.split(';')
    app_url = split[0]
    time = split[2]
    nonce = split[3]

    return 'blank public key' if public_key.n.nil?
    return "the app url in the manifest (#{manifest['application_base_url']}) does not match the url passed in the parameters (#{app_url})." if manifest["application_base_url"] != app_url
    return 'key too small, use at least 2048 bits' if public_key.n.num_bits < 2048
    return "invalid time" unless valid_time?(time)
    return 'invalid nonce' unless valid_nonce?(nonce)
    return 'invalid signature' unless verify_signature(signed_string, sig, public_key)
    'ok'
  end

  def verify_signature(challenge, signature, public_key)
    public_key.verify(OpenSSL::Digest::SHA256.new, signature, challenge)
  end

  def valid_time?(time)
    time.to_i > (Time.now - 5.minutes).to_i
  end

  def valid_nonce?(nonce)
    !OAuth2::Provider.client_class.exists?(:nonce => nonce)
  end

  def redirect_or_block_invalid_authorization_code_requests
    begin
      block_invalid_authorization_code_requests
    rescue OAuth2::Provider::Rack::InvalidRequest => e
      if e.message == "client_id is invalid"
        redirect_to params[:redirect_uri]+"&error=invalid_client"
      else
        raise
      end
    end
  end
end
