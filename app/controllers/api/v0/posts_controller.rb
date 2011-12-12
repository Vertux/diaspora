#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class Api::V0::PostsController < Api::V0::ApplicationController
  def show
    post = Post.where(:id => params[:id]).first
    if (params[:type] && params[:type] == 'photo') ||
       (post.blank? && params[:type].blank?)
      post = Photo.where(:id => params[:id]).first
    end
    
    if post
      respond_to do |format|
        format.xml { render_for_api :v0_private_post_info, :xml => post }
        format.json { render_for_api :v0_private_post_info, :json => post }
      end
    else
      head :not_found
    end
  end
end
