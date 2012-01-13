#   Copyright (c) 2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module Api::V0::Photo
  extend ActiveSupport::Concern
  included do
    api_accessible :v0_private_photo_info do |tpl|
      tpl.add :id
      tpl.add :diaspora_handle
      tpl.add :public
      tpl.add :api_v0_type, :as => :type
      tpl.add :created_at
      tpl.add :comments_count
      tpl.add :api_v0_urls, :as => :urls
      tpl.add "status_message.id", :as => :status_message_id
    end
  end
    
  def api_v0_private_post_info_template
    :v0_private_photo_info
  end
  
  def api_v0_type
    'Photo'
  end
  
  def api_v0_urls
    Hash[*["medium", "large"].collect { |name| 
      prefix = self.author.url.chomp("/") unless self.url[0..3] == "http"
      [name, "#{prefix}#{self.url("thumb_"+name)}"]
    }.flatten]
  end
end
