module Tincanz
  class Inbox
    def initialize(user, params)
      @user = user
      @current_filter = params[:tab] || 'All'
    end

    def conversations
      if @user.can_manage_tincanz?
        return filtered
      else
        Conversation.involving(@user)
      end
    end
    
    def filtered
      return case @current_filter
      when 'All' then all
      when 'Yours' then yours
      when 'Nobody' then nobody
      else 
        raise @current_filter.inspect
      end
    end

    def all
      Conversation.all
    end

    def yours
      Conversation.where(user_id: @user.id)
    end

    def nobody
      Conversation.where(user_id: nil)
    end
  end

end