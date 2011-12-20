#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'

describe "API V0 notifications" do
  context "a user with some unread notifications" do
    before do
      @user = Factory :user
      @notifications = []
      3.times do
        notification = Factory :notification, :recipient => @user
        @notifications << {
          :id => notification.id,
          :type => notification.api_v0_type,
          :target_id => notification.target_id,
          :unread => notification.unread,
          :actor_handles => notification.api_v0_actor_handles
        }
      end
    end
    
    context "unauthenticated" do
      it "fails" do
        get '/api/v0/notifications', :format => :json
        response.should_not be_success
      end
    end
    
    context "authenticated" do
      before do
        get '/api/v0/notifications', api_v0_params(:user => @user)
      end
      
      it "success" do
        response.should be_success
      end
      
      it "returns the right informations" do
        response.body.should be_json_eql @notifications.to_json
      end
    end
  end
end
