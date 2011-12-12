#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module Api::V0::StatusMessage
  extend ActiveSupport::Concern
  included do
    api_accessible :v0_private_post_info do |tpl|
      tpl.add :text
      tpl.add :photos
      tpl.remove :root
    end
  end
end
