#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'

describe "API V0 people" do
  before do
    @user = Factory :user_with_aspect
    @searchable = Factory :searchable_person
    @unsearchable = Factory :unsearchable_person
    @contact = Factory :contact, :user => @user, :sharing => true
    @user.add_contact_to_aspect(@contact, @user.aspects.first)
  end
  
  context "unauthenticated" do
    it "fails" do
      get "/api/v0/people/#{@searchable.guid}", :format => :json
      response.should_not be_success
    end
  end
  
  context "authenticated" do
    context "requesting via guid" do
      it "returns the right informations for a searchable person" do
        get "/api/v0/people/#{@searchable.guid}", api_v0_params
        response.body.should be_json_eql({
          :guid => @searchable.guid,
          :diaspora_handle => @searchable.diaspora_handle,
          :first_name => @searchable.first_name,
          :last_name => @searchable.last_name,
          :image_urls => @searchable.api_v0_image_urls
        }.to_json)
      end
      
      it "returns the right informations for a sharing contact" do
        get "/api/v0/people/#{@contact.person.guid}", api_v0_params(:user => @user)
        response.body.should be_json_eql({
          :guid => @contact.person.guid,
          :diaspora_handle => @contact.person.diaspora_handle,
          :first_name => @contact.person.first_name,
          :last_name => @contact.person.last_name,
          :image_urls => @contact.person.api_v0_image_urls,
          :birthday => @contact.person.profile.birthday,
          :gender => @contact.person.profile.gender,
          :bio => @contact.person.profile.bio,
          :location => @contact.person.profile.location
        }.to_json)
      end
      
      it "returns a 404 for a not searchable person" do
        get "/api/v0/people/#{@unsearchable.guid}", api_v0_params
        response.status.should == 404
      end
    end
    
    context "requesting via handle" do
      it "returns the right informations for a searchable person" do
        username, pod = @searchable.diaspora_handle.split("@")
        get "/api/v0/people/#{pod}/#{username}", api_v0_params
        response.body.should be_json_eql({
          :guid => @searchable.guid,
          :diaspora_handle => @searchable.diaspora_handle,
          :first_name => @searchable.first_name,
          :last_name => @searchable.last_name,
          :image_urls => @searchable.api_v0_image_urls
        }.to_json)
      end
      
      it "returns the right informations for a sharing contact" do
        username, pod = @contact.person.diaspora_handle.split("@")
        get "/api/v0/people/#{pod}/#{username}", api_v0_params(:user => @user)
        response.body.should be_json_eql({
          :guid => @contact.person.guid,
          :diaspora_handle => @contact.person.diaspora_handle,
          :first_name => @contact.person.first_name,
          :last_name => @contact.person.last_name,
          :image_urls => @contact.person.api_v0_image_urls,
          :birthday => @contact.person.profile.birthday,
          :gender => @contact.person.profile.gender,
          :bio => @contact.person.profile.bio,
          :location => @contact.person.profile.location
        }.to_json)
      end
      
      it "returns a 404 for a not searchable person" do
        username, pod = @unsearchable.diaspora_handle.split("@")
        get "/api/v0/people/#{pod}/#{username}", api_v0_params
        response.status.should == 404
      end
    end
  end
end
