require "rails_helper"

describe 'Conversations', type: :feature do
  
  let!(:admin){ create(:admin) }
  let!(:user){ create(:user) }


  context "anonymous user" do
    it 'is redirected to main_app.sign in path by default' do
      visit tincanz.conversations_path
      expect(page.current_path).to eq('/users/sign_in')
    end
  end

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

      it 'only displays messages user is participant of' do
        sender = create(:user)
        innocent = create(:user)

        message_a = create(:message, content: 'hello', user: sender, recipients: [user])
        message_b = create(:message, content: 'long time no see', user: user, recipients: [sender])
        message_c = create(:message, content: 'private problem', user: innocent, recipients: [sender])

        conv = create(:conversation, messages: [message_a, message_b, message_c])

        visit tincanz.conversations_path

        within(selector_for :first_conversation) do
          click_link 'Read more'
        end

        expect(page.current_path).to eq tincanz.conversation_path(conv)
        assert_seen message_a.content, within: :conversation_message
        assert_seen message_b.content, within: :first_reply

        expect(page).to_not have_content message_c.content
      end

    end

    context 'creating a conversation' do

      it 'is valid with content' do
        visit tincanz.new_conversation_path

        fill_in 'Content', with: 'can you help me?'
        click_button 'Send'
    
        flash_notice!('Your message was delivered')
        expect(page.current_path).to eq tincanz.conversations_path
        assert_seen 'can you help me?', within: :first_conversation
      end

      it 'is invalid with no content' do
        visit tincanz.new_conversation_path
        click_button 'Send'
        flash_alert!('Could not create your message.')
      end

    end
  end
end