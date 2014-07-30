module Tincanz
  class ConversationPolicy
    def initialize(user, conversation)
      @user = user
      @conversation = conversation
    end

    def can_read?
      if @user.can_manage_tincanz?
        true
      else
        Conversation.involving(@user).where(id: @conversation.id).count > 0
      end
    end

    def can_reply?
      can_read?
    end
  end
end