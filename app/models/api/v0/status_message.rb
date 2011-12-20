#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module Api::V0::StatusMessage
  extend ActiveSupport::Concern
  included do
    api_accessible :v0_private_status_message_info, :extend => :v0_private_post_info do |tpl|
      tpl.add :text
      tpl.add :photos, :template => :v0_private_photo_info
    end
    
    api_accessible :v0_private_reshare_info, :extend => :v0_private_status_message_info do |tpl|
    end
    
    api_accessible :v0_private_stream_post_info, :extend => :v0_private_status_message_info do |tpl|
    end
    
    def api_v0_private_post_info_template
      :v0_private_status_message_info
    end
  end
end
