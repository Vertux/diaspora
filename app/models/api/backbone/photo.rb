#   Copyright (c) 2012, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module Api::Backbone::Photo
  extend ActiveSupport::Concern
  included do
    api_accessible :backbone do |t|
      t.add :id
      t.add :guid
      t.add :created_at
      t.add :author
      t.add lambda { |photo|
        { :small => photo.url(:thumb_small),
          :medium => photo.url(:thumb_medium),
          :large => photo.url(:scaled_full) }
      }, :as => :sizes
    end
  end
end
