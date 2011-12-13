class OAuth2::Provider::Models::ActiveRecord::Client
  has_many :oauth_client_permissions, :dependent => :destroy
  
  def self.find_or_create_from_manifest!(manifest, pub_key)
    client = find_by_name(manifest['name'])
    
    unless client
      client = self.create!(
        :name => manifest["name"],
        :description => manifest["description"],
        :permissions_overview => manifest["permissions_overview"],
        :application_base_url => manifest["application_base_url"],
        :icon_url => manifest["icon_url"],
        :public_key => pub_key.export
      )
      
      
      manifest["permissions"].each do |permission|
        OauthClientPermission.create!(:client_id => client.id,
                                      :scope => permission["type"],
                                      :access_type => permission["access"])
      end
    end
    
    client
  end
  
  def permissions
    self.oauth_client_permissions
  end
end
