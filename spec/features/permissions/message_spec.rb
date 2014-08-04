require "rails_helper"

describe 'Message permissions', type: :feature do

  let(:hacker){ create(:user) }


  context "not a recipient of the message being replied to" do
    it "can not create a message" do
      victim  = create(:user)
      message = create(:message, user: victim)
      conv    = create(:conversation, messages: [message])

      sign_in hacker

      visit tincanz.new_conversation_message_path(conv, reply_to_id: message.id)
      assert_unauthorized
    end
  end
end