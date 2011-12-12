#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class Api::V0::UsersController < Api::V0::ApplicationController
  skip_before_filter :oauth_authenticate!, :only => :show #temp
  
  def me
    respond_to do |format|
      format.any { render_for_api :v0_me_info, :json => @user }
    end
  end
  
  def show
    if user = User.find_by_username(params[:username])
      respond_with user, :api_template => :v0_private_user_info
    else
      head :not_found
    end
  end
end
