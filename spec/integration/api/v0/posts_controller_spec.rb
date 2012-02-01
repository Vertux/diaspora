#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'

describe "API V0 posts" do
  context "accessing a single public post" do
    before do
      @post = Factory :status_message, :public => true
    end
    
    context "unauthenticated" do
      it "fails" do
        get "/api/v0/posts/#{@post.id}", :format => :json
        response.should_not be_success
      end
    end
    
    context "authenticated" do
      before do
        get "/api/v0/posts/#{@post.id}", api_v0_params
      end
      
      it "succeeds" do
        response.should be_success
      end
      
      it "returns the right info" do
        res = parse_json(response.body)
        {:id => @post.id,
         :guid => @post.guid,
         :diaspora_handle => @post.diaspora_handle,
         :public => @post.public,
         :provider_display_name => @post.provider_display_name,
         :type => @post.type,
         :created_at => @post.created_at,
         :comments_count => @post.comments_count,
         :likes_count => @post.likes_count
        }.each do |key, val|
          res[key.to_s].to_json.should == val.to_json
        end
      end
    end
  end
  
  it "returns the right informations if accessing a single post the authenticated user can see" do
    user = Factory :user_with_aspect
    friend = Factory :user_with_aspect
    my_aspect = user.aspects.first
    his_aspect = friend.aspects.first
    connect_users(user, my_aspect, friend, his_aspect)
    msg = friend.post(:status_message, :text => "awesome", :to => his_aspect)
    
    get "/api/v0/posts/#{msg.id}", api_v0_params(:user => user)
  
    res = parse_json(response.body)
    {:id => msg.id,
     :guid => msg.guid,
     :diaspora_handle => msg.diaspora_handle,
     :public => msg.public,
     :provider_display_name => msg.provider_display_name,
     :type => msg.type,
     :created_at => msg.created_at,
     :comments_count => msg.comments_count,
     :likes_count => msg.likes_count
    }.each do |key, val|
      res[key.to_s].to_json.should == val.to_json
    end
  end
  
  it "returns the right informations accesing a status message" do
    user = Factory :user
    msg = Factory :status_message, :author => user.person
    
    get "/api/v0/posts/#{msg.id}", api_v0_params(:user => user)
    
    response.body.should be_json_eql({
      :id => msg.id,
      :guid => msg.guid,
      :diaspora_handle => msg.diaspora_handle,
      :public => msg.public,
      :provider_display_name => msg.provider_display_name,
      :type => msg.type,
      :created_at => msg.created_at,
      :comments_count => msg.comments_count,
      :likes_count => msg.likes_count,
      :text => msg.text,
      :photos => msg.photos.as_api_response(:v0_private_post_info)
    }.to_json)
  end
  
  it "returns the right informations accessing a reshare" do
    reshare = Factory :reshare
    
    get "/api/v0/posts/#{reshare.id}", api_v0_params
    
    response.body.should be_json_eql({
      :id => reshare.id,
      :guid => reshare.guid,
      :diaspora_handle => reshare.diaspora_handle,
      :public => reshare.public,
      :provider_display_name => reshare.provider_display_name,
      :type => reshare.type,
      :created_at => reshare.created_at,
      :comments_count => reshare.comments_count,
      :likes_count => reshare.likes_count,
      :root => reshare.root.as_api_response(:v0_private_reshare_info)
    }.to_json)
  end
  
  it "returns the right informations accessing a photo" do
    msg = Factory :status_message_with_photo, :public => true
    photo = msg.photos.first
    
    get "/api/v0/posts/#{photo.id}", api_v0_params
  
    response.body.should be_json_eql({
      :id => photo.id,
      :guid => photo.guid,
      :diaspora_handle => photo.diaspora_handle,
      :public => photo.public,
      :type => photo.api_v0_type,
      :created_at => photo.created_at,
      :comments_count => photo.comments_count,
      :urls => photo.api_v0_urls,
      :status_message_id => msg.id
    }.to_json)
  end
  
  it "returns the right informations accessing an activity streams photo" do
    photo = Factory :activity_streams_photo
    
    get "/api/v0/posts/#{photo.id}", api_v0_params
    
    response.body.should be_json_eql({
      :id => photo.id,
      :guid => photo.guid,
      :diaspora_handle => photo.diaspora_handle,
      :public => photo.public,
      :provider_display_name => photo.provider_display_name,
      :type => photo.type,
      :created_at => photo.created_at,
      :comments_count => photo.comments_count,
      :likes_count => photo.likes_count,
      :image_url => photo.image_url,
      :object_url => photo.object_url
    }.to_json)
  end
  
  context "with a post and a photo with the same id" do
    before do
      @msg = Factory :status_message_with_photo, :public => true
      @id = @msg.id
      photo = @msg.photos.first
      
      ActiveRecord::Base.connection.execute("UPDATE photos SET id = #{@id} WHERE id = #{photo.id}")
      @photo = Photo.find(@id)
    end
    
    it "returns the post by default" do
      get "/api/v0/posts/#{@id}", api_v0_params
      res = parse_json(response.body)
      res["id"].should == @id
      res["type"].should == @msg.type
    end
    
    it "returns the photo if requested" do
      get "/api/v0/posts/#{@id}", api_v0_params(:type => 'photo')
      res = parse_json(response.body)
      res["id"].should == @id
      res["type"].should == @photo.api_v0_type
    end
    
    it "returns the post if requested" do
      get "/api/v0/posts/#{@id}", api_v0_params(:type => 'post')
      res = parse_json(response.body)
      res["id"].should == @id
      res["type"].should == @msg.type
    end
  end
  
  it "allows querying via a guid" do
    msg = Factory :status_message, :public => true
    get "/api/v0/posts/#{msg.guid}", api_v0_params(:guid => true)
    response.should be_success
  end
end
