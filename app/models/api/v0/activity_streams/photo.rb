#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module Api::V0::ActivityStreams::Photo
  extend ActiveSupport::Concern
  included do
    api_accessible :v0_private_activity_streams_photo_info, :extend => :v0_private_post_info do |tpl|
      tpl.add :image_url
      tpl.add :object_url
    end
    
    api_accessible :v0_private_reshare_info, :extend => :v0_private_activity_streams_photo_info do |tpl|
    end
    
    api_accessible :v0_private_stream_post_info, :extend => :v0_private_activity_streams_photo_info do |tpl|
    end
    
    def api_v0_private_post_info_template
      :v0_private_activity_streams_photo_info
    end
  end
end
