require_dependency "tincanz/application_controller"

module Tincanz
  class Admin::MessagesController < ApplicationController

    before_filter :authenticate_tincanz_user
    before_filter :authorize_admin
    before_filter :find_conversation
    
    def new
      find_reply_to
      @message = @conversation.messages.new(reply_to: @reply_to, 
                                            user: tincanz_user, 
                                            recipient_ids: [@reply_to.user.id], 
                                            content: "\n\n----\n\n#{@reply_to.content}",
                                            conversation: @conversation)
    end

    def create
      @message = @conversation.messages.build(message_params)
      @message.user = tincanz_user

      if @message.save
        flash.notice = t('tincanz.conversations.replied')
        redirect_to(admin_conversation_path(@conversation))
      else
        flash.alert = t('tincanz.conversations.not_replied')
        render :new
      end
    end

    private

    def message_params
      params.require(:message).permit(:conversation_id, :user_id, :content, :recipient_ids_string)
    end

    def find_conversation
      @conversation = Conversation.find(params[:conversation_id])
    end

    def find_reply_to
      @reply_to = Message.where(id: params[:reply_to_id]).first
    end
  end
end
