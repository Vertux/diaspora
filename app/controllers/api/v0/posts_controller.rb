#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.


class Api::V0::PostsController < Api::V0::ApplicationController
  def show
    ensure_permission!(:posts, :read)
    
    if post = Api::V0::Post.api_v0_find_visible_by_type(current_user, params[:id], params[:type])
      template = (post.respond_to?(:api_v0_private_post_info_template)) ? post.api_v0_private_post_info_template : :v0_private_post_info
      respond_with post, :api_template => template
    else
      head :not_found
    end
  end
end
