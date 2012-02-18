#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class Api::V0::PeopleController < Api::V0::ApplicationController
  def show
    ensure_permission!(:people, :read)
    
    if params[:id]
      person = ::Person.searchable.where(:guid => params[:id]).first
    elsif params[:pod] && params[:username]
      handle = "#{params[:username]}@#{params[:pod]}"
      person = ::Person.searchable.where(:diaspora_handle => handle).first
    end
    
    if person
      contact = current_user.contact_for(person)
      template = (contact && contact.sharing?) ? :v0_private_person_info : :v0_public_person_info
      respond_with person, :api_template => template
    else
      head :not_found
    end
  end
end
