require_dependency "tincanz/application_controller"

module Tincanz
  class Admin::MessagesController < ApplicationController

    before_filter :authenticate_tincanz_user
    before_filter :authorize_admin
    
    def new
      @message = Message.new
    end

    def create
      @conversation = Conversation.where(id: params[:conversation_id]).first || Conversation.create(user: tincanz_user)
      @message = @conversation.messages.new(message_params)

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
      params.require(:message).permit(:user_id, :content)
    end
  end
end
