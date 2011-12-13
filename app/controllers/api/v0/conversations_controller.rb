#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class Api::V0::ConversationsController < Api::V0::ApplicationController
  def index
    ensure_permission!(:conversations, :read)
    
    conversations = ::Conversation.joins(:conversation_visibilities).where(
      :conversation_visibilities => {:person_id => @user.person.id}).all
    respond_with conversations, :api_template => :v0_private_conversation_info
  end
  
  def show
    ensure_permission!(:conversations, :read)
    
    if conversation = ::Conversation.joins(:conversation_visibilities).where(
       :id => params[:id], :conversation_visibilities => {
         :person_id => @user.person.id}).first
      
      respond_with conversation.messages, :api_template => :v0_private_message_info
    else
      head :not_found
    end
  end
end
