#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class Api::V0::CommentsController < Api::V0::ApplicationController
  def index
    ensure_permission(:comments, :read)
    
    if post = Post.api_v0_find_visible_by_type(@user, params[:post_id], params[:post_type])
      respond_with post.comments, :api_template => :v0_private_comment_info
    else
      head :not_found
    end
  end
end
