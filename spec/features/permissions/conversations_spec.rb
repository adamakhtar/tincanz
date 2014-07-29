require "rails_helper"

describe 'Conversation permissions', type: :feature do

  let(:hacker){ create(:user) }


  context "without ability to view a specific conversation" do
    it "is denied access" do
      victim = create(:user)
      conv   = create(:conversation, messages: [create(:message, user: victim)])

      sign_in hacker

      visit tincanz.conversation_path(conv)
      assert_unauthorized
    end
  end
end