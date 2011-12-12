#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class Api::V0::LikesController < Api::V0::ApplicationController
  def index
    if post = Post.api_v0_find_by_type(params[:post_id], params[:post_type])
      respond_with post.likes, :api_template => :v0_private_like_info
    else
      head :not_found
    end
  end
end
