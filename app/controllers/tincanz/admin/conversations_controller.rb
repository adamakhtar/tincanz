require_dependency "tincanz/application_controller"

module Tincanz
  class Admin::ConversationsController < ApplicationController
    before_filter :authenticate_tincanz_user

    respond_to :html

    def index
      @conversations = Conversation.all
      respond_with @conversations
    end

    def show
      @conversation = Conversation.find(params[:id])
      @messages     = @conversation.messages.most_recent
      @message      = @conversation.messages.build
    end
  end
end
