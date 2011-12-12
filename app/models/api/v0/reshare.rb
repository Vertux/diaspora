#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module Api::V0::Reshare
  extend ActiveSupport::Concern
  included do
    api_accessible :v0_private_post_info do |tpl|
      tpl.add :root
    end
  end
end
