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
      authorize! ConversationPolicy.new(tincanz_user, @conversation).can_read?
      @stream       = ConversationStream.new(tincanz_user, @conversation)
      respond_with @conversation
    end

    def new
      @conversation = Conversation.new
      @message      = @conversation.messages.build
      respond_with @conversation
    end

    def create
      @conversation = ConversationComposer.compose(tincanz_user, conversation_params)
    
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
