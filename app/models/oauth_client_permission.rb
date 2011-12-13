class OauthClientPermission < ActiveRecord::Base
  belongs_to :client, :class_name => OAuth2::Provider::Models::ActiveRecord::Client
  attr_accessible :client_id, :scope, :access_type
  validates_presence_of :client_id, :scope, :access_type
  validates_inclusion_of :access_type, :in => ["read", "write"]
  validates_inclusion_of :scope, :in => ["posts","as_photos", "comments", 
                                         "likes", "aspects", "profile", "people"]
end
