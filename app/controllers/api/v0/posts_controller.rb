#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.


class Api::V0::PostsController < Api::V0::ApplicationController
  def show
    if post = Post.api_v0_find_by_type(params[:id], params[:type])
      respond_to do |format|
        format.xml { render_for_api :v0_private_post_info, :xml => post }
        format.json { render_for_api :v0_private_post_info, :json => post }
      end
    else
      head :not_found
    end
  end
end
