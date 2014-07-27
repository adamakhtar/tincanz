# Creates new message and when applicable inserts the contents
# of the message being replied to at the end of its content 

module Tincanz
  class MessageComposer
    def initialize(params)
      @message = Message.new(params)
    end

    def self.compose(params)
      new(params).compose
    end

    def compose
      if @message.reply_to
        @message.content << "\n\n------\n#{@message.reply_to.user.tincanz_email} wrote:\n#{@message.reply_to.content}"
      end
      @message
    end
  end
end