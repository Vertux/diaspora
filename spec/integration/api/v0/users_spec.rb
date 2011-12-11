#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'

describe "API V0 users" do
  let(:user) { Factory :user }
  
  context 'requesting an existing user' do
    before do
      get '/api/v0/users/'+user.username, :format => :json
    end
    
    it 'succeeds' do
      response.should be_success
    end
    
    it 'returns the right diaspora_id, image_url, first_name, last_name and searchable' do
      response.body.should == {:diaspora_id => user.profile.diaspora_handle,
                               :image_url => user.profile.image_url,
                               :first_name => user.profile.first_name,
                               :last_name => user.profile.last_name,
                               :searchable => user.profile.searchable}.to_json
    end
  end
  
  context 'invalid requests' do
    it 'should fail for a not existing user' do
      get '/api/v0/users/foo', :format => :json
      response.should_not be_success
    end
    
    it 'should fail for requesting the wrong format' do
      get '/api/v0/users/'+user.username
      response.should_not be_success
    end
  end
  
  context 'requesting the authenticated user' do
    before do
      pending "setup fake oauth auth in specs"
    end
    
    it 'succeeds' do
      response.should be_success
    end
    
    it 'returns the right name, uid and birthday' do
      response.body.should == {:name => user.person.name,
                               :uid => user.username,
                               :birthday => user.profile.birthday}.to_json
    end
  end
end
