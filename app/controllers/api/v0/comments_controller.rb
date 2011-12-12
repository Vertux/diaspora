#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class Api::V0::CommentsController < Api::V0::ApplicationController
  def index
    if post = Post.api_v0_find_by_type(params[:post_id], params[:post_type])
      respond_to do |format|
        format.xml { render_for_api :v0_private_comment_info, :xml => post.comments }
        format.json { render_for_api :v0_private_comment_info, :json => post.comments }
      end
    else
      head :not_found
    end
  end
end
