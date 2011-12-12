#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module Api::V0::Conversation
  extend ActiveSupport::Concern
  included do
    acts_as_api
    
    api_accessible :v0_private_conversation_info do |tpl|
      tpl.add :id
      tpl.add :subject
      tpl.add :diaspora_handle
    end
  end
end
