require "rails_helper"

describe 'Message permissions', type: :feature do

  let(:hacker){ create(:user) }


  context "not a member of a conversation" do
    it "can not create a message" do
      victim = create(:user)
      conv   = create(:conversation, messages: [create(:message, user: victim)])

      sign_in hacker

      visit tincanz.new_conversation_message_path(conv)
      assert_unauthorized
    end
  end
end