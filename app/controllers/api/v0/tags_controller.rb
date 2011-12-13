#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class Api::V0::TagsController < Api::V0::ApplicationController
  skip_before_filter :oauth_authenticate!, :only => [:show]
  
  def show
    if tag = Api::V0::Tag.find_by_name(params[:name])
      respond_with tag, :api_template => :v0_public_tag_info
    else
      head :not_found
    end
  end
  
  def followed_tags
    ensure_permission!(:tags, :read)

    tags = current_user.followed_tags.collect { |tag| tag.name }

    respond_to do |format|
      format.xml { render :xml => tags }
      format.json { render :json => tags }
    end
  end
end
