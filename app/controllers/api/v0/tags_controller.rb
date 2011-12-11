#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class Api::V0::TagsController < Api::V0::ApplicationController
  skip_before_filter :oauth_authenticate!, :only => [:show]
  
  def show
    if tag = Api::V0::Templates::Tag.find_by_name(params[:name])
      respond_to do |format|
        format.xml { render_for_api :v0_public_tag_info, :xml => tag }
        format.any { render_for_api :v0_public_tag_info, :json => tag }
      end
    else
      head :not_found
    end
  end
end
