#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module Api::V0::Templates
  module User
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
  
  class Tag < ActsAsTaggableOn::Tag
    acts_as_api
    
    api_accessible :v0_public_tag_info do |tpl|
      tpl.add :name
      tpl.add :person_count
      tpl.add :followed_count
      tpl.add :posts
    end
    
    def posts
      []
    end
    
    def person_count
      Person.profile_tagged_with(self.name).count
    end
  end
  
  module Post
    extend ActiveSupport::Concern
    included do
      acts_as_api
      
      api_accessible :v0_private_post_info do |tpl|
        tpl.add :id
        tpl.add :diaspora_handle
        tpl.add :public
        tpl.add :provider_display_name
        tpl.add :type
        tpl.add :created_at
        tpl.add :comments_count
        tpl.add :likes_count
      end
    end
    
    module StatusMessage
      extend ActiveSupport::Concern
      included do
        api_accessible :v0_private_post_info do |tpl|
          tpl.add :text
          tpl.add :photos
          tpl.remove :root
        end
      end
    end
    
    module Reshare
      extend ActiveSupport::Concern
      included do
        api_accessible :v0_private_post_info do |tpl|
          tpl.add :root
        end
      end
    end
    
    module ActivityStreams
      module Photo
        extend ActiveSupport::Concern
        included do
          api_accessible :v0_private_post_info do |tpl|
            tpl.add :image_url
            tpl.add :object_url
            tpl.remove :root
          end
        end
      end
    end
  end
    
  module Photo
    extend ActiveSupport::Concern
    included do
      acts_as_api 
      
        api_accessible :v0_private_post_info do |tpl|
          tpl.add :id
          tpl.add :diaspora_handle
          tpl.add :public
          tpl.add :provider_display_name
          tpl.add :api_v0_type, :as => :type
          tpl.add :created_at
          tpl.add :comments_count
          tpl.add :likes_count
          tpl.add :api_v0_urls, :as => :urls
          tpl.add "status_message.id", :as => :status_message_id
        end
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
  
  
  module Comment
    extend ActiveSupport::Concern
    included do
      acts_as_api
      
      api_accessible :v0_private_comment_info do |tpl|
        tpl.add :text
        tpl.add "author.diaspora_handle", :as => :diaspora_handle
        tpl.add :created_at
        tpl.add :likes_count
      end
    end
  end
end
