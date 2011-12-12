#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class Api::V0::CommentsController < Api::V0::ApplicationController
  def index
    post = Post.where(:id => params[:post_id]).first
    if (params[:post_type] && params[:post_type] == 'photo') ||
       (post.blank? && params[:type].blank?)
      post = Photo.where(:id => params[:post_id]).first
    end
    
    if post
      respond_to do |format|
        format.xml { render_for_api :v0_private_comment_info, :xml => post.comments }
        format.json { render_for_api :v0_private_comment_info, :json => post.comments }
      end
    else
      head :not_found
    end
  end
end
