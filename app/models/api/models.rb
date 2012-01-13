#   Copyright (c) 2012, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module Api::Models
  module Aspect
    extend ActiveSupport::Concern
    included do
      acts_as_api
      
      include Api::V0::Aspect
    end
  end
  
  module Comment
    extend ActiveSupport::Concern
    included do
      acts_as_api
      
      include Api::Backbone::Comment
      include Api::V0::Comment
    end
  end
  
  module Contact
    extend ActiveSupport::Concern
    included do
      acts_as_api
      
      include Api::V0::Contact
    end
  end
  
  module Conversation
    extend ActiveSupport::Concern
    included do
      acts_as_api
      
      include Api::V0::Conversation
    end
  end
  
  module Like
    extend ActiveSupport::Concern
    included do
      acts_as_api
      
      include Api::Backbone::Like
      include Api::V0::Like
    end
  end
  
  module Message
    extend ActiveSupport::Concern
    included do
      acts_as_api
      
      include Api::V0::Message
    end
  end
  
  module Notification
    extend ActiveSupport::Concern
    included do
      acts_as_api
      
      include Api::V0::Notification
    end
  end
  
  module Person
    extend ActiveSupport::Concern
    included do
      acts_as_api
      
      include Api::Backbone::Person
      include Api::V0::Person
    end
  end
  
  module Photo
    extend ActiveSupport::Concern
    included do
      acts_as_api
      
      include Api::Backbone::Photo
      include Api::V0::Photo
    end
  end
  
  module Post
    extend ActiveSupport::Concern
    included do
      acts_as_api
      
      include Api::Backbone::Post
      include Api::V0::Post
    end
  end
  
  module Reshare
    extend ActiveSupport::Concern
    included do
      include Api::V0::Reshare
    end
  end
  
  module StatusMessage
    extend ActiveSupport::Concern
    included do
      include Api::V0::StatusMessage
    end
  end
  
  module User
    extend ActiveSupport::Concern
    included do
      acts_as_api
      
      include Api::V0::User
    end
  end
end
