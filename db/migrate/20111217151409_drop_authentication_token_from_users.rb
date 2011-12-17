require File.join(Rails.root, "db/migrate/20110518184453_add_token_auth_to_user")

class DropAuthenticationTokenFromUsers < ActiveRecord::Migration
  def self.up
    AddTokenAuthToUser.down
  end

  def self.down
    AddTokenAuthToUser.up
  end
end
