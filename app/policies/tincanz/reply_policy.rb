module Tincanz

  class ReplyPolicy
    
    def initialize(user, reply)
      @user  = user
      @reply = reply
    end

    def can_reply?
      if @user.can_manage_tincanz?
        true
      else
        @reply.recipients.include? @user
      end
    end
  end

end