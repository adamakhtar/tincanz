require_dependency "tincanz/application_controller"

module Tincanz
  class ConversationsController < ApplicationController
    def index
      @conversations = Conversation.involving(tincanz_user)
    end

    def show
    end
  end
end
