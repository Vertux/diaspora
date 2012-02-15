#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class FakeOAuth2
  def authenticate_request!(scope=nil)
  end
  
  def authenticated?
    true
  end
  
  def resource_owner
    alice
  end
  
  def authorization
    @authorization ||= oauth_authorization
  end
end
