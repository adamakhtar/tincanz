require_dependency "tincanz/application_controller"

module Tincanz
  class MessagesController < ApplicationController

    before_filter :find_conversation 
    before_filter :authorize_reply_to_conversation, only: [:new, :create]

    respond_to :html

    def new
      @reply_to = @conversation.messages.find_by_id(params[:reply_to_id]) 
      @message = @conversation.messages.build(user: tincanz_user, 
                                              reply_to: @reply_to, 
                                              recipient_ids: [@reply_to.user.id], 
                                              content: "\n\n----\n\n#{@reply_to.content}")
      respond_with @message
    end

    def create
      @message = @conversation.messages.build(message_params)
      @message.user = tincanz_user

      if @message.save
        flash.notice = t('tincanz.conversations.replied')
      else
        flash.alert = t('tincanz.conversations.not_replied')
      end

      respond_with @message do |f|
        f.html do
          @message.persisted? ? redirect_to(conversations_path) : render(action: :new)
        end
      end
    end

    private

    def authorize_reply_to_conversation
      authorize! ConversationPolicy.new(tincanz_user, @conversation).can_reply?
    end

    def find_conversation
      @conversation = Conversation.find(params[:conversation_id])
    end

    def message_params
      params.require(:message).permit(:reply_to_id, :content)
    end
  end
end
