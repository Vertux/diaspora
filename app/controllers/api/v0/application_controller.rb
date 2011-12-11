#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class Api::V0::ApplicationController < ApplicationController
  before_filter :oauth_authenticate!
  before_filter :set_user_from_oauth
  respond_to :json, :xml
  
  
  private
  
  def oauth_authenticate!(options={})
      filter = OAuth2::Provider::Rails::ControllerAuthentication::ClassMethods::AuthenticationFilter.new(options.delete(:scope))
      filter.filter(self) do
      end
  end
  
  def set_user_from_oauth
    @user = request.env['oauth2'].resource_owner
  end
  
end
