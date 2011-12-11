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
      get '/api/v0/tags/'+@tag.name, :format => :json
      response.should be_success
    end
    
    it "doesn't require authentication" do
      pending
      get '/api/v0/tags/'+@tag.name, :format => :json
      response.should be_success
    end
    
    it 'returns the right name, followed_count, person_count and posts' do
      posts = []
      get '/api/v0/tags/'+@tag.name, :format => :json
      response.body.should == {:name => @tag.name.to_s,
                               :followed_count => @tag.followed_count,
                               :person_count => Person.profile_tagged_with(@tag.name).count,
                               :posts => posts }.to_json
    end
  end
end
