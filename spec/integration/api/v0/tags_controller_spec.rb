#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'

describe "API V0 tags" do
  context 'requesting information about a tag' do
    before do
      @tag = Factory :tag
    end
    
    it 'succeds' do
      get '/api/v0/tags/'+@tag.name, api_v0_params
      response.should be_success
    end
    
    it "doesn't require authentication" do
      get '/api/v0/tags/'+@tag.name, :format => :json
      response.should be_success
    end
    
    it 'returns the right name, followed_count, person_count and posts' do
      posts = []
      get '/api/v0/tags/'+@tag.name, api_v0_params
      JSON.parse(response.body).symbolize_keys.should == {
        :name => @tag.name.to_s,
        :followed_count => @tag.followed_count,
        :person_count => Person.profile_tagged_with(@tag.name).count,
        :posts => posts
      }
    end
  end
  
  context 'accessing followed tags' do
    context 'without authentication' do
      it 'fails' do
        get '/api/v0/followed_tags', :format => :json
        response.should_not be_success
      end
    end
    
    context 'with an authenticated user that follows some tags' do
      before do
        user = Factory :user
        @tags = []
        3.times do
          tag = Factory :tag
          @tags << tag.name.to_s
          Factory :tag_following, :tag => tag, :user => user
        end
        get '/api/v0/followed_tags', api_v0_params(:user => user)
      end
      
      it 'succeeds' do
        response.should be_success
      end
      
      it 'responds with the right tags' do
        response.body.should be_json_eql(@tags.to_json)
      end
    end
  end
end
