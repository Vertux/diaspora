#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

ENV["RAILS_ENV"] ||= 'test'
require File.join(File.dirname(__FILE__), '..', 'config', 'environment') unless defined?(Rails)
require 'helper_methods'
require 'spec-doc'
require 'rspec/rails'
require 'webmock/rspec'
require 'factory_girl'

include WebMock::API
WebMock::Config.instance.allow_localhost = false
include HelperMethods

# Force fixture rebuild
FileUtils.rm_f(File.join(Rails.root, 'tmp', 'fixture_builder.yml'))

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
fixture_builder_file = "#{File.dirname(__FILE__)}/support/fixture_builder.rb"
support_files = Dir["#{File.dirname(__FILE__)}/support/**/*.rb"] - [fixture_builder_file]
support_files.each {|f| require f }
require fixture_builder_file

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.mock_with :rspec

  config.use_transactional_fixtures = true

  config.before(:each) do
    I18n.locale = :en
    stub_request(:post, "https://pubsubhubbub.appspot.com/")

    $process_queue = false
  end

  config.before(:each, :type => :controller) do
    self.class.render_views
  end

  config.after(:all) do
    `rm -rf #{Rails.root}/tmp/uploads/*`
  end
end

Dir["#{File.dirname(__FILE__)}/shared_behaviors/**/*.rb"].each do |f|
  require f
end

disable_typhoeus
ProcessedImage.enable_processing = false

def set_up_friends
  [local_luke, local_leia, remote_raphael]
end

def alice
  @alice ||= User.where(:username => 'alice').first
end

def bob
  @bob ||= User.where(:username => 'bob').first
end

def eve
  @eve ||= User.where(:username => 'eve').first
end

def local_luke
  @local_luke ||= User.where(:username => 'luke').first
end

def local_leia
  @local_leia ||= User.where(:username => 'leia').first
end

def remote_raphael
  @remote_raphael ||= Person.where(:diaspora_handle => 'raphael@remote.net').first
end

def photo_fixture_name
  @photo_fixture_name = File.join(File.dirname(__FILE__), 'fixtures', 'button.png')
end

def oauth_client
  unless @oauth_client
    @oauth_client = Factory :app
    [:tags, :as_photos, :aspects, :comments].each do |perm|
      [:read, :write].each do |access|
        @oauth_client.oauth_client_permissions << Factory(:oauth_client_permission,
                                                          :client_id => @oauth_client.id,
                                                          :scope => perm.to_s,
                                                          :access_type => access.to_s)
      end
    end
  end
  @oauth_client
end

def oauth_authorization(opts={})
  client = opts.delete(:client) || oauth_client
  user = opts.delete(:user) || alice
  @oauth_authorizations ||= Hash.new
  @oauth_authorizations[client.id] ||= Hash.new
  @oauth_authorizations[client.id][user.id] ||= Factory :oauth_authorization,
                                                        :client => client,
                                                        :resource_owner => user
end

def oauth_access_token(authorization=nil)
  authorization ||= oauth_authorization
  token = Factory :oauth_access_token, :authorization => authorization
  token.access_token
end

def api_v0_params(opts={})
  if user = opts.delete(:user)
    token = oauth_access_token(oauth_authorization(:user => user))
  else
    token = oauth_access_token
  end
  
  {:format => :json, :oauth_token => token}.merge(opts)
end
