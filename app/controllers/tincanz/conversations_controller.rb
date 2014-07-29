require_dependency "tincanz/application_controller"

module Tincanz
  class ConversationsController < ApplicationController

    before_filter :authenticate_tincanz_user

    def index
      @conversations = Conversation.involving(tincanz_user) 
    end

    def show
      @conversation = Conversation.find(params[:id])

      if ConversationPolicy.new(tincanz_user, @conversation).can_read?
        @first_message       = @conversation.first_message
        @subsequent_messages = @conversation.subsequent_messages.involving(tincanz_user)
      else
        handle_unauthorized
      end
    end
  end
end
