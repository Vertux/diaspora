#   Copyright (c) 2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class Api::V0::Tag < ActsAsTaggableOn::Tag
  acts_as_api
  
  api_accessible :v0_tag_name do |tpl|
    tpl.add :name
  end
  
  api_accessible :v0_public_tag_info, :extend => :v0_tag_name do |tpl|
    tpl.add :name
    tpl.add :person_count
    tpl.add :followed_count
    tpl.add :posts
  end
  
  def posts
    []
  end
  
  def person_count
    ::Person.profile_tagged_with(self.name).count
  end
end
