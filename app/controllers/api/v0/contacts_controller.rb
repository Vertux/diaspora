#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class Api::V0::ContactsController < Api::V0::ApplicationController
  def index
    ensure_permission!(:aspects, :read)
    ensure_permission!(:people, :read)
    
    contacts = current_user.contacts
    
    if params[:aspect_ids]
      aspect_ids = params[:aspect_ids].split(",").collect { |id| id.to_i }
      contacts.collect! {|c| c if c.api_v0_has_one_of_aspect_ids?(aspect_ids) }
      contacts.compact!
    end
    
    respond_with contacts, :api_template => :v0_private_contact_info
  end
end
