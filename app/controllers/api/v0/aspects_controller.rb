#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class Api::V0::AspectsController < Api::V0::ApplicationController
  def index
    ensure_permission!(:aspects, :read)

    respond_with current_user.aspects, :api_template => :v0_private_aspect_info
  end
end
