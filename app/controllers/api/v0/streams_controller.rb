#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require File.join(Rails.root, 'lib', 'stream', 'multi')
require File.join(Rails.root, 'lib','stream', 'comments')
require File.join(Rails.root, 'lib','stream', 'likes')
require File.join(Rails.root, 'lib','stream', 'mention')

class Api::V0::StreamsController < Api::V0::ApplicationController
  def main
    stream_action(Stream::Multi)
  end

  def commented
    stream_action(Stream::Comments)
  end
  
  def liked
    stream_action(Stream::Likes)
  end
  
  def mentions
    stream_action(Stream::Mention)
  end
  
  private
  def stream_action(stream_class)
    stream = stream_class.new(@user, :max_time => max_time, :sort_order => sort_order)
    
    respond_to do |format|
      format.xml { render_for_api :v0_private_post_info, :xml => stream.stream_posts }
      format.json { render_for_api :v0_private_post_info, :json => stream.stream_posts }
    end
  end
  
  def sort_order
    params[:sort_order] ? params[:sort_order] : 'created_at'
  end
end
