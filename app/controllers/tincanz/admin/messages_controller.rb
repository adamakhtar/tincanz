require_dependency "tincanz/application_controller"

module Tincanz
  class Admin::MessagesController < ApplicationController

    before_filter :authenticate_tincanz_user
    before_filter :authorize_admin
    
    def new
      find_reply_to
      if @reply_to 
        @message = Message.new(reply_to: @reply_to, user: tincanz_user, recipient_ids: [@reply_to.user.id], content: "\n\n----\n\n#{@reply_to.content}", conversation: @reply_to.conversation)
      elsif params[:recipient_ids] and !@reply_to
        @message = Message.new(reply_to: @reply_to, user: tincanz_user, recipient_ids: params[:recipient_ids])
      end
    end

    def create
      Conversation.transaction do 
        find_conversation
        @message = @conversation.messages.new(message_params.except(:conversation_id))
      end
      
      if @message.save
        flash.notice = t('tincanz.messages.created')
        redirect_to admin_conversation_path(@message.conversation)
      else
        flash.alert  = t('tincanz.messages.not_created')
         render :new
      end
    end

    private

    def message_params
      params.require(:message).permit(:conversation_id, :user_id, :content, :recipient_ids_string)
    end

    def find_conversation
      @conversation = Conversation.find_or_create_by(id: message_params[:conversation_id]) do |conversation|
        conversation.user = tincanz_user
      end
    end

    def find_reply_to
      @reply_to = Message.where(id: params[:reply_to_id]).first
    end
  end
end
