#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module Api::V0::Comment
  extend ActiveSupport::Concern
  included do
    api_accessible :v0_private_comment_info do |tpl|
      tpl.add :id
      tpl.add :text
      tpl.add "author.diaspora_handle", :as => :diaspora_handle
      tpl.add :created_at
      tpl.add :likes_count
    end
  end
end
