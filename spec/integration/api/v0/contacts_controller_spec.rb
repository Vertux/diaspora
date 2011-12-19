#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'

describe "API v0 contacts" do
  context "accessing the list of contacts of the current user" do
    context "without authentication" do
      it "fails" do
        get '/api/v0/contacts', :format => :json
        response.should_not be_success
      end
    end
    
    context "with an authenticated user with some contacts" do
      before do
        @user = Factory :user
        @contacts = []
        @aspects = {}
        5.times do |n|
          aspect = Factory :aspect, :user => @user, :name => "contact #{n}"
          contact = Factory :contact, :user => @user
          @user.add_contact_to_aspect(contact, aspect)
          contact_info = {:diaspora_handle => contact.person.diaspora_handle,
                        :aspect_ids => contact.aspects.collect {|a| a.id },
                        :following => contact.receiving?,
                        :followed => contact.sharing?}
          @aspects[aspect.id] ||= []
          @aspects[aspect.id] << contact_info
          @contacts << contact_info
        end
      end
      
      it "succeeds" do
        get '/api/v0/contacts', api_v0_params(:user => @user)
        response.should be_success
      end
      
      it "responds with all contacts" do
        get '/api/v0/contacts', api_v0_params(:user => @user)
        response.body.should be_json_eql @contacts.to_json
      end
      
      it "filters the contacts by aspect ids" do
        aspect_ids = @aspects.keys[0..1]
        contacts = @aspects[aspect_ids[0]]
        contacts.concat(@aspects[aspect_ids[1]])
        get '/api/v0/contacts', api_v0_params(:user => @user, :aspect_ids => aspect_ids.join(","))
        response.body.should be_json_eql contacts.to_json
      end
    end
  end
end
