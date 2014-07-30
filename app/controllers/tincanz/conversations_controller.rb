require_dependency "tincanz/application_controller"

module Tincanz
  class ConversationsController < ApplicationController

    before_filter :authenticate_tincanz_user

    respond_to :html

    def index
      @conversations = Conversation.involving(tincanz_user) 
      respond_with @conversations
    end

    def show
      @conversation = Conversation.find(params[:id])
      
      if ConversationPolicy.new(tincanz_user, @conversation).can_read?
        @first_message       = @conversation.first_message
        @subsequent_messages = @conversation.subsequent_messages.involving(tincanz_user)
        respond_with @conversation
      else
        handle_unauthorized
      end
    end

    def new
      @conversation = Conversation.new
      @message      = @conversation.messages.build
      respond_with @conversation
    end

    def create
      @conversation = Conversation.new(conversation_params)
      message       = @conversation.messages.first
      message.recipients = Tincanz.user_class.tincanz_admin
      message.user       = tincanz_user

      if @conversation.save
        flash.notice = t('tincanz.messages.created')
      else
        flash.alert  = t('tincanz.messages.not_created')
      end

      respond_with @conversation, location: conversations_path
    end

    private

    def conversation_params
      params.require(:conversation).permit(:messages_attributes => [[:content]])
    end
  end
end
