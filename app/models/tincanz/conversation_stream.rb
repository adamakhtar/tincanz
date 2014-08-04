module Tincanz

  class ConversationStream

    def initialize(user, conversation)
      @user = user
      @conversation = conversation
    end

    def first_message
      messages.first
    end

    def subsequent_messages
      messages[1..-1]
    end

    private

    def messages
      @user.can_manage_tincanz? ? @conversation.messages : @conversation.messages.involving(@user)
    end

  end

end