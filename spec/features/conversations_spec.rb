require "rails_helper"

describe 'Conversations', type: :feature do
  
  let(:admin){ create(:admin) }
  let(:user){ create(:user) }

  context "signed in as user" do

    before do
      sign_in user
    end

    it 'lists only involved conversations' do
      villain = create(:user)
      
      message_a = create(:message, content: 'hey', user: user)
      conv_a = create(:conversation, messages: [message_a])

      message_b = create(:message, content: 'yo', user: user)
      conv_b = create(:conversation, messages: [message_b])

      message_c = create(:message, content: 'sup', user: villain)
      conv_c = create(:conversation, messages: [message_c])

      visit tincanz.conversations_path
      conversations = Nokogiri::HTML(page.body).css(".conversations-list .conversation-message").map(&:text)
      expect(conversations).to eq [message_a.content, message_b.content]
    end

    context 'displaying conversation' do

      it 'displays messages' do
        sender = create(:user)
        message_a = create(:message, content: 'hello', user: sender, recipients: [user])
        message_b = create(:message, content: 'long time no see', user: user, recipients: [sender])

        conv = create(:conversation, messages: [message_a, message_b])

        visit tincanz.conversations_path

        within(selector_for :first_conversation) do
          click_link 'Read more'
        end

        page!

        expect(page.current_path).to eq tincanz.conversation_path(conv)
        assert_seen message_a.content, within: :conversation_message
        assert_seen message_b.content, within: :first_reply
      end

    end
  end
end