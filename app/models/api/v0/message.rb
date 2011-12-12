#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module Api::V0::Message
  extend ActiveSupport::Concern
  included do
    acts_as_api
    
    api_accessible :v0_private_message_info do |tpl|
      tpl.add :created_at
      tpl.add :diaspora_handle
      tpl.add :text
    end
  end
end
