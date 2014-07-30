require_dependency "tincanz/application_controller"

module Tincanz
  class Admin::ConversationsController < ApplicationController
    before_filter :authenticate_tincanz_user
    before_filter :authorize_admin

    respond_to :html

    def index
      @conversations = Conversation.all
      respond_with @conversations
    end

    def show
      @conversation        = Conversation.find(params[:id])
      @first_message       = @conversation.first_message
      @subsequent_messages = @conversation.subsequent_messages
    end

    def new
      @conversation = Conversation.new
      @message      = @conversation.messages.build
      @message.recipient_ids = params[:recipient_ids]

      respond_with @conversation
    end

    def create
      @conversation = Conversation.new(conversation_params)
      message       = @conversation.messages.first
      message.user  = tincanz_user

      if @conversation.save
        flash.notice = t('tincanz.messages.created')
        redirect_to admin_conversation_path(@conversation)
      else
        flash.alert  = t('tincanz.messages.not_created')
        redirect_to new_admin_conversation_path(@conversation)
      end

      
    end

    private

    def conversation_params
      params.require(:conversation).permit(:messages_attributes => [[:content, :recipient_ids_string]])
    end
  end
end
