#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class Api::V0::ActivityStreams::PhotosController < Api::V0::ApplicationController
  def create
    ensure_permission!(:as_photos, :write)
    
    @photo = ActivityStreams::Photo.from_activity(params[:activity])
    @photo.author = current_user.person
    @photo.public = true

    if @photo.save
      Rails.logger.info("event=create type=activitystreams_photo")

      current_user.add_to_streams(@photo, current_user.aspects)
      current_user.dispatch_post(@photo, :url => post_url(@photo))

      render :nothing => true, :status => 201
    else
      render :nothing => true, :status => 422
    end
  end
end
