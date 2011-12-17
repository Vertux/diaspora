#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'

describe "API V0 users" do
  context 'requesting an existing user' do
    before do
      get '/api/v0/users/'+alice.username, api_v0_params
    end
    
    it 'succeeds' do
      response.should be_success
    end
    
    it 'returns the right diaspora_id, image_url, first_name, last_name and searchable' do
      response.body.should == {:diaspora_id => alice.profile.diaspora_handle,
                               :image_url => alice.profile.image_url,
                               :first_name => alice.profile.first_name,
                               :last_name => alice.profile.last_name,
                               :searchable => alice.profile.searchable}.to_json
    end
  end
  
  context 'invalid requests' do
    it 'should fail for a not existing user' do
      get '/api/v0/users/foo', api_v0_params
      response.should_not be_success
    end
    
    it 'should fail for requesting the wrong format' do
      get '/api/v0/users/'+alice.username, api_v0_params(:format => :html)
      response.should_not be_success
    end
  end
  
  context 'requesting the authenticated user' do
    before do
      get '/api/v0/users/me', api_v0_params
    end
    
    it 'succeeds' do
      response.should be_success
    end
    
    it 'returns the right name, uid and birthday' do
      response.body.should == {:name => alice.person.name,
                               :uid => alice.username,
                               :birthday => alice.profile.birthday}.to_json
    end
  end
end
