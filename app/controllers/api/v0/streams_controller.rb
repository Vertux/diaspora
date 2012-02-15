#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require File.join(Rails.root, 'lib', 'stream', 'multi')
require File.join(Rails.root, "lib", 'stream', "aspect")
require File.join(Rails.root, 'lib','stream', 'comments')
require File.join(Rails.root, 'lib','stream', 'likes')
require File.join(Rails.root, 'lib','stream', 'mention')
require File.join(Rails.root, 'lib', 'stream', 'followed_tag')
require File.join(Rails.root, 'lib', 'stream', 'tag')

class Api::V0::StreamsController < Api::V0::ApplicationController
  before_filter do
    ensure_permission!(:posts, :read)
  end
  
  def main
    stream_action(Stream::Multi)
  end

  def aspects
    aspect_ids = (params[:aspect_ids]) ? params[:aspect_ids].split(",") : []
    stream_action(Stream::Aspect, :second_param => aspect_ids)
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
  
  def followed_tags
    stream_action(Stream::FollowedTag)
  end
  
  def tag
    stream_action(Stream::Tag, :second_param => params[:name])
  end
  
  private
  
  def stream_action(stream_class, opts={})
    opts = {:max_time => max_time, :sort_order => sort_order}.merge(opts)
    if second_param = opts.delete(:second_param)
      stream = stream_class.new(current_user, second_param, opts)
    else
      stream = stream_class.new(current_user, opts)
    end

    respond_with stream.stream_posts, :api_template => :v0_private_stream_post_info
  end
  
  def sort_order
    params[:sort_order] ? params[:sort_order] : 'created_at'
  end
end
