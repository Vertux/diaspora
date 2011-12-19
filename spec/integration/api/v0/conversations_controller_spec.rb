#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'

describe "API V0 conversations" do
  context "getting a list of conversations" do
    before do
      @user = Factory :user
      @conversations = []
      contact = Factory :contact, :user => @user
      3.times do
        conversation = Factory :conversation, :author => @user.person
        @conversations << {
          :id => conversation.id,
          :subject => conversation.subject,
          :diaspora_handle => conversation.author.diaspora_handle
        }
      end
    end
    
    context "unauthenticated" do
      it "fails" do
        get '/api/v0/conversations', :format => :json
        response.should_not be_success
      end
    end
    
    context "authenticated" do
      before do
        get '/api/v0/conversations', api_v0_params(:user => @user)
      end
      
      it "succeeds" do
        response.should be_success
      end
      
      it "returns the right infos" do
        response.body.should be_json_eql @conversations.to_json
      end
    end
  end
  
  context "getting messages of a conversation" do
    before do
      @user = Factory :user
      @conversation = Factory :conversation, :author => @user.person
      @messages = []
      message = @conversation.messages.first
      @messages << {
        :diaspora_handle => message.author.diaspora_handle,
        :created_at => message.created_at,
        :text => message.text
      }
      3.times do
        message = Factory :message, :conversation => @conversation
        @messages << {
          :diaspora_handle => message.author.diaspora_handle,
          :created_at => message.created_at,
          :text => message.text
        }
      end
    end
    
    context "unauthenticated" do
      it "fails" do
        get "/api/v0/conversations/#{@conversation.id}", :format => :json
        response.should_not be_success
      end
    end
    
    context "authenticated" do
      before do
        get "/api/v0/conversations/#{@conversation.id}", api_v0_params(:user => @user)
      end
      
      it "succeeds" do
        response.should be_success
      end
      
      it "returns the right informations" do
        response.body.should be_json_eql @messages.to_json
      end
    end
  end
end
