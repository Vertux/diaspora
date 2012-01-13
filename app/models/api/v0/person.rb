#   Copyright (c) 2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module Api::V0::Person
  extend ActiveSupport::Concern
  included do
    api_accessible :v0_public_person_info do |tpl|
      tpl.add :diaspora_handle
      tpl.add :first_name
      tpl.add :last_name
      tpl.add :api_v0_image_urls, :as => :image_urls
    end
    
    api_accessible :v0_private_person_info, :extend => :v0_public_person_info do |tpl|
      tpl.add "profile.birthday", :as => :birthday
      tpl.add "profile.gender", :as => :gender
      tpl.add "profile.bio", :as => :bio
      tpl.add "profile.location", :as => :location
    end
  end
  
  def api_v0_image_urls
    {:small => self.profile.image_url_small,
     :medium => self.profile.image_url_medium,
     :large => self.profile.image_url}
  end
end
