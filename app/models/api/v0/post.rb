#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module Api::V0::Post
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
  
  def self.api_v0_find_by_type(id, type=nil)
    post = ::Post.where(:id => id).first
    if type == 'photo' ||
       (post.blank? && type.blank?)
      post = ::Photo.where(:id => id).first
    end
    post
  end
end
