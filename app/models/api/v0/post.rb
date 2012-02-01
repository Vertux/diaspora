#   Copyright (c) 2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module Api::V0::Post
  extend ActiveSupport::Concern
  included do
    api_accessible :v0_private_post_info do |tpl|
      tpl.add :id
      tpl.add :guid
      tpl.add :diaspora_handle
      tpl.add :public
      tpl.add :provider_display_name
      tpl.add :type
      tpl.add :created_at
      tpl.add :comments_count
      tpl.add :likes_count
    end
  end
  
  def self.api_v0_find_visible_by_type(user, id, type=nil, key=:id)
    if user
      post = user.find_visible_shareable_by_id(::Post, id, :key => key)
      if type == 'photo' || (post.blank? && type.blank?)
        post = user.find_visible_shareable_by_id(::Photo, id, :key => key)
      end
    end
    
    unless post
      post = ::Post.where(key => id, :public => true).first
      if type == 'photo' || (post.blank? && type.blank?)
        ::Photo.where(key => id, :public => true).first
      end
    end
    
    post
  end
end
