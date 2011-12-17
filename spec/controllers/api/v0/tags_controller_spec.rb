#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'

describe Api::V0::TagsController do
  before do
    Factory :tag, :name => 'alice'
  end
  
  describe '#show' do
    it 'succeeds' do
      get :show, api_v0_params(:name => 'alice')
      response.should be_success
    end

    it "returns the basic tag data" do
      get :show, api_v0_params(:name => 'alice')
      parsed_json = JSON.parse(response.body)
      parsed_json.keys.should =~ %w(name person_count followed_count posts)
    end
  end
end
