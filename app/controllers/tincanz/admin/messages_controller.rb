require_dependency "tincanz/application_controller"

module Tincanz
  class Admin::MessagesController < ApplicationController

    before_filter :authenticate_tincanz_user
    before_filter :authorize_admin
    
    def create
      @message = Message.new(message_params)

      if @message.save
        flash.notice = t('tincanz.conversations.replied')
      else
        flash.alert  = t('tincanz.conversations.not_replied')
      end

      redirect_to admin_conversation_path(@message.conversation)
    end

    private

    def message_params
      params.require(:message).permit(:conversation_id, :user_id, :content)
    end
  end
end
