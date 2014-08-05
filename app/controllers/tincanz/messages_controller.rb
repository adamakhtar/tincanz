require_dependency "tincanz/application_controller"

module Tincanz
  class MessagesController < ApplicationController

    before_filter :find_conversation
    before_filter :find_reply_to
    before_filter :authorize_conversation!
    before_filter :authorize_reply_to!

    respond_to :html

    def new
      @message = @conversation.messages.build(user: tincanz_user, 
                                              reply_to: @reply_to, 
                                              recipient_ids: [@reply_to.user.id], 
                                              content: "\n\n----\n\n#{@reply_to.content}")
      respond_with @message
    end

    def create
      @message  = @conversation.messages.build(message_params)
      @message.user = tincanz_user
    
      if @message.save
        flash.notice = t('tincanz.conversations.replied')
      else
        flash.alert = t('tincanz.conversations.not_replied')
      end

      respond_with @message do |f|
        f.html do
          @message.persisted? ? redirect_to(conversation_path(@conversation)) : render(action: :new)
        end
      end
    end

    private

    def find_conversation
      @conversation = Conversation.find(params[:conversation_id])
    end

    def find_reply_to
      @reply_to = Message.find(params[:reply_to_id] || message_params[:reply_to_id])
    end

    def authorize_conversation!
      authorize! ConversationPolicy.new(tincanz_user, @conversation).can_read?
    end

    def authorize_reply_to!
      authorize! ReplyPolicy.new(tincanz_user, @reply_to).can_read?
    end

    def message_params
      params.require(:message).permit(:reply_to_id, :content, :recipient_ids_string)
    end
  end
end
