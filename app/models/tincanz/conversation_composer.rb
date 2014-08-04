# Creates new conversation with first message from params
# Allows admin to create with multiple recipients but 
# ensures user initiated messages are always sent to admin 
# and not other users.

module Tincanz
  class ConversationComposer

    delegate :recipient_ids, :content, :user, to: :message

    def self.compose(user, params)
      new(user, params).compose
    end

    def initialize(user, params)
      @user = user
      @params = params
    end

    def compose
      conversation = Conversation.new(@params)
      message = conversation.messages.first

      message.user = @user
      message.recipients = Tincanz.user_class.tincanz_admin unless @user.can_manage_tincanz?
      conversation.messages = [message] # HACK - prevent user from created multiple nested attribute records.

      conversation
    end
  end
end

