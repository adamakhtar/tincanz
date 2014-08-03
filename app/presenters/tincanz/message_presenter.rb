module Tincanz
  class MessagePresenter

    def initialize(context, message, args={})
      @context = context
      @message = message
      @current_user = args[:current_user]
      @recipients   = @message.recipients
    end

    def author
      @message.user == @current_user ? "You" : @message.user.tincanz_email
    end

    def created_at
      @message.created_at.strftime('%d/%m/%Y')
    end

    def multiple_recipients?
      @recipients.count > 1
    end
 
    def recipient
      if admin?
        if user_is_recipient?
          multiple_recipients? ? "you and #{@recipients.count - 1} others"  : 'you'  
        else
          multiple_recipients? ? "#{@recipients.count} people"  : @recipients.first.tincanz_email
        end
      else
        user_is_recipient? ? 'you' : @recipients.first.tincanz_email
      end
    end

    def recipients
      @recipients
    end

    def user_is_recipient?
      !!@recipients.where(id: @current_user.id).first
    end

    def admin?
      @current_user.can_manage_tincanz?
    end
  end
end