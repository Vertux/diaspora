#   Copyright (c) 2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module Api::V0::Like
  extend ActiveSupport::Concern
  included do
    api_accessible :v0_private_like_info do |tpl|
      tpl.add :positive
      tpl.add "author.diaspora_handle", :as => :diaspora_handle
      tpl.add :created_at
    end
  end
end
