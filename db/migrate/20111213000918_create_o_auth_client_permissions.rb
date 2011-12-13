class CreateOAuthClientPermissions < ActiveRecord::Migration
  def self.up
    create_table :oauth_client_permissions do |t|
      t.integer :id
      t.integer :client_id
      t.string :scope, :limit => 127
      t.string :access_type, :limit => 127
    end
  end

  def self.down
    drop_table :oauth_client_permissions
  end
end
