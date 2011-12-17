#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'

describe "API V0 aspects" do
  context 'retriving the list of aspects of the current user' do
    before do
      user = Factory :user
      @aspects = []
      3.times do |n|
        aspect = Factory :aspect, :name => "api#{n}", :user => user
        @aspects << {"id" => aspect.id, "name" => aspect.name.to_s}
      end
      get '/api/v0/aspects', api_v0_params(:user => user)
    end
    
    it 'succeeds' do
      response.should be_success
    end
    
    it 'responds with a list of the authenticated users aspects' do
      response.body.should == @aspects.to_json
    end
  end
end
