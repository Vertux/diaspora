#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'

describe "API V0 likes" do
  context "a user with a post with some likes" do
    before do
      @user = Factory :user
      @post = Factory :status_message, :author => @user.person
      @likes = []
      3.times do
        like = Factory :like, :parent => @post
        @likes << {
          :positive => like.positive,
          :diaspora_handle => like.author.diaspora_handle,
          :created_at => like.created_at
        }
      end
    end
      
    context "unauthenticated" do
      it "fails" do
        get "/api/v0/posts/#{@post.id}/likes", :format => :json
        response.should_not be_success
      end
    end
    
    context "authenticated" do
      before do
        get "/api/v0/posts/#{@post.id}/likes", api_v0_params(:user => @user)
      end
      
      it "succeeds" do
        response.should be_success
      end
      
      it "returns the right infos" do
        response.body.should be_json_eql @likes.to_json
      end
    end
  end
end
