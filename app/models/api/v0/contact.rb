#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module Api::V0::Contact
  extend ActiveSupport::Concern
  included do
    acts_as_api
    
    api_accessible :v0_private_contact_info do |tpl|
      tpl.add "person.diaspora_handle", :as => :diaspora_handle
      tpl.add :api_v0_aspect_ids, :as => :aspect_ids
      tpl.add :sharing?, :as => :followed
      tpl.add :receiving?, :as => :following
    end
  end
  
  def api_v0_aspect_ids
    @api_v0_aspect_ids ||= self.aspect_memberships.collect { |as| as.aspect_id }
  end
  
  def api_v0_has_one_of_aspect_ids?(aspect_ids)
    aspect_ids.each do |aspect_id|
      return true if api_v0_aspect_ids.include?(aspect_id)
    end
    return false
  end
end
