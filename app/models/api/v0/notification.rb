#   Copyright (c) 2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module Api::V0::Notification
  extend ActiveSupport::Concern
  included do
    api_accessible :v0_private_notification_info do |tpl|
      tpl.add :id
      tpl.add :api_v0_type, :as => :type
      tpl.add :unread
      tpl.add :target_id
      tpl.add :api_v0_actor_handles, :as => :actor_handles
    end
  end
  
  def api_v0_type
    self.type.split("::")[1]
  end
  
  def api_v0_actor_handles
    @api_v0_actor_handles ||= self.actors.collect { |actor| actor.diaspora_handle }
  end
end
