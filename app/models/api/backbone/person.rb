#   Copyright (c) 2012, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module Api::Backbone::Person
  extend ActiveSupport::Concern
  included do
    api_accessible :backbone do |t|
      t.add :id
      t.add :name
      t.add lambda { |person|
        person.diaspora_handle
      }, :as => :diaspora_id
      t.add lambda { |person|
        {:small => person.profile.image_url(:thumb_small),
        :medium => person.profile.image_url(:thumb_medium),
        :large => person.profile.image_url(:thumb_large) }
      }, :as => :avatar
    end
  end
end
