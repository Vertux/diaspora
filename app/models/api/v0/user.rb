#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module Api::V0::User
  extend ActiveSupport::Concern
  included do
    acts_as_api
    
    api_accessible :v0_me_info do |tpl|
      tpl.add "person.name", :as => :name
      tpl.add :username, :as => :uid
      tpl.add "profile.birthday", :as => :birthday
    end
    
    api_accessible :v0_private_user_info do |tpl|
      tpl.add "person.diaspora_handle", :as => :diaspora_id
      tpl.add "profile.first_name", :as => :first_name
      tpl.add "profile.last_name", :as => :last_name
      tpl.add "profile.image_url", :as => :image_url
      tpl.add "profile.searchable", :as => :searchable
    end
  end
end
