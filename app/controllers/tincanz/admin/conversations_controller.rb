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
      @recipient    = User.find(params[:user_id])
      @conversation = Conversation.new(user: tincanz_user)
      @message      = @conversation.messages.build(user: @recipient)
    end
  end
end
