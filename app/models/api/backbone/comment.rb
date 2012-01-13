#   Copyright (c) 2012, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module Api::Backbone::Comment
  extend ActiveSupport::Concern
  included do
    api_accessible :backbone do |t|
      t.add :id
      t.add :guid
      t.add :text
      t.add :author
      t.add :created_at
    end
  end
end
