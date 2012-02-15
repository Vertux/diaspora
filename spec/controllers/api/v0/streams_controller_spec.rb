#   Copyright (c) 2012, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'

describe Api::V0::StreamsController do
  let(:params) { {:max_time => 123456789, :sort_order => 'created_at'} }
  let(:opts) { {:max_time => Time.at(123456789), :sort_order => 'created_at'} }
  before do
    request.env['oauth2'] = FakeOAuth2.new
    @stream_stub = stub
    @stream_stub.stub!(:stream_posts)
  end

  describe "#main" do
    it "succeeds" do
      get :main, api_v0_params
    end
    
    it "calls the multi stream" do
      Stream::Multi.should_receive(:new).with(alice, opts).and_return(@stream_stub)
      get :main, api_v0_params(opts)
    end
  end

  describe "#aspects" do
    it "succeeds" do
      get :aspects, api_v0_params
    end

    it "calls the aspect stream" do
      Stream::Aspect.should_receive(:new).with(alice, [], opts).and_return(@stream_stub)
      get :aspects, api_v0_params(opts)
    end

    it "carries over aspect ids" do
      aspect_ids = alice.aspects.map { |a| a.id.to_s }
      Stream::Aspect.should_receive(:new).with(alice, aspect_ids, opts).and_return(@stream_stub)
      get :aspects, api_v0_params(opts.merge(:aspect_ids => aspect_ids.join(",")))
    end
  end

  describe "#commented" do
    it "succeeds" do
      get :commented, api_v0_params
    end

    it "calls the comments stream" do
      Stream::Comments.should_receive(:new).with(alice, opts).and_return(@stream_stub)
      get :commented, api_v0_params(opts)
    end
  end

  describe "#liked" do
    it "succeeds" do
      get :liked, api_v0_params
    end

    it "calls the likes stream" do
      Stream::Likes.should_receive(:new).with(alice, opts).and_return(@stream_stub)
      get :liked, api_v0_params(opts)
    end
  end

  describe "#mentions" do
    it "succeeds" do
      get :mentions, api_v0_params
    end

    it "calls the mention stream" do
      Stream::Mention.should_receive(:new).with(alice, opts).and_return(@stream_stub)
      get :mentions, api_v0_params(opts)
    end
  end

  describe "#followed_tags" do
    it "succeeds" do
      get :followed_tags, api_v0_params
    end

    it "calls the followed tag stream" do
      Stream::FollowedTag.should_receive(:new).with(alice, opts).and_return(@stream_stub)
      get :followed_tags, api_v0_params(opts)
    end
  end

  describe "#tag" do
    it "succeeds" do
      get :tag, api_v0_params(:name => "foo")
    end

    it "calls the tag stream" do
      tag = "foo"
      Stream::Tag.should_receive(:new).with(alice, tag, opts).and_return(@stream_stub)
      get :tag, api_v0_params(opts.merge(:name => tag))
    end
  end
end
