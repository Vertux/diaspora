#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.
require File.join(Rails.root, 'app/models/oauth2_provider_models_activerecord_client')


class Api::V0::ApplicationController < ApplicationController
  include OAuth2::Provider::Rack::Responses
  before_filter :oauth_authenticate!
  before_filter :setup_from_oauth
  self.responder = ActsAsApi::Responder
  respond_to :json, :xml
  
  protected
  
  def ensure_permission!(scope, access=:read)
    if access == :read
      perms = @oauth_client.permissions.reading
    elsif access == :write
      perms = @oauth_client.permissions.writing
    end
    insufficient_scope! unless (params[:bypass] && !params[:test_check]) || perms && perms.where(:scope => scope.to_s).exists?
  end
  
  private
  
  def oauth_authenticate!(options={})
    unless params[:bypass]
      request.env['oauth2'].authenticate_request!(nil)
    end
  end
  
  def setup_from_oauth
    if params[:bypass]
      sign_in User.first
      @oauth_client = OAuth2::Provider::Models::ActiveRecord::Client.first
    else
      sign_in request.env['oauth2'].resource_owner
      @oauth_client = request.env['oauth2'].authorization.client
    end
  end
end
