#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'

describe "API V0 comments" do
  context "reading comments" do
    context "unauthenticated" do
      before do
        post = Factory :status_message, :public => true
        get "/api/v0/posts/#{post.id}/comments", :format => :json
      end
      
      it "fails" do
        response.should_not be_success
      end
    end
  
    context "authenticated" do
      context "of a public post" do
        before do
          msg = Factory :status_message, :public => true
          get "/api/v0/posts/#{msg.id}/comments", api_v0_params
        end
        
        it "succeeds" do
          response.should be_success
        end
      end
    end
    
    context "of my own post" do
      before do
        user = Factory :user
        msg = Factory :status_message, :author => user.person
        get "/api/v0/posts/#{msg.id}/comments", api_v0_params(:user => user)
      end
      
      it "succeeds" do
        response.should be_success
      end
    end
    
    context "of a post I can see" do
      before do
        user = Factory :user
        friend = Factory :user
        my_aspect = Factory :aspect, :user => user
        his_aspect = Factory :aspect, :user => friend
        connect_users(user, my_aspect, friend, his_aspect)
        msg = friend.post(:status_message, :text => "awesome", :to => his_aspect)
        @comments = []
        3.times do
          comment = Factory :comment, :post => msg
          @comments << {"id" => comment.id,
                        "text" => comment.text,
                        "diaspora_handle" => comment.author.diaspora_handle,
                        "created_at" => comment.created_at,
                        "likes_count" => comment.likes_count}
        end
        get "/api/v0/posts/#{msg.id}/comments", api_v0_params(:user => user)
      end
      
      it "succeeds" do
        response.should be_success
      end
      
      it "returns a list of comments" do
        response.body.should == @comments.to_json
      end
    end
    
    context "of a post I can't see" do
      before do
        user = Factory :user
        friend = Factory :user
        msg = Factory :status_message, :author => friend.person
        get "/api/v0/posts/#{msg.id}/comments", api_v0_params(:user => user)
      end
      
      it "returns a 404" do
        response.status.should == 404
      end
    end
  end
end
