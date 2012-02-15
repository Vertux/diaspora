#   Copyright (c) 2012, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module Api::Backbone::Post
  extend ActiveSupport::Concern
  included do
    api_accessible :backbone do |t|
      t.add :id
      t.add :guid
      t.add lambda { |post|
        post.raw_message
      }, :as => :text
      t.add :public
      t.add :created_at
      t.add :interacted_at
      t.add :comments_count
      t.add :likes_count
      t.add :reshares_count
      t.add :last_three_comments
      t.add :provider_display_name
      t.add :author
      t.add :post_type
      t.add :image_url
      t.add :object_url
      t.add :root
      t.add :o_embed_cache
      t.add :user_like
      t.add :user_participation
      t.add :mentioned_people
      t.add :photos
      t.add :nsfw
    end
  end
end
