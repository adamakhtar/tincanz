require_dependency "tincanz/application_controller"

module Tincanz
  class ConversationsController < ApplicationController

    def index
      @conversations = Conversation.involving(tincanz_user) 
    end

    def show
      @conversation = Conversation.find(params[:id])
      @first_message       = @conversation.first_message
      @subsequent_messages = @conversation.subsequent_messages
    end
  end
end
