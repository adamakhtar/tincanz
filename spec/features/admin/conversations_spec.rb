require "rails_helper"

describe 'admin::conversations', type: :feature do
  
  let(:admin){ create(:admin) }

  context "signed in as normal user" do
    it 'redirects to apps root path' do
      sign_in create(:user)
      visit tincanz.admin_conversations_path 
      assert_unauthorized
    end
  end

  context "signed in as admin" do

    before do
      sign_in admin
    end

    context 'reading conversations' do 

      it 'lists all' do
        conv_a = create(:conversation)
        conv_b = create(:conversation)

        visit tincanz.admin_conversations_path
        
        conversations = Nokogiri::HTML(page.body).css(".conversations-list .subject").map(&:text)
        expect(conversations.size).to eq 2
      end

      it 'displays single' do
        conv = create(:conversation)
        message_a = create(:message, content: 'fiz', conversation: conv, created_at: 1.days.ago)
        message_b = create(:message, content: 'buz', conversation: conv, created_at: 10.days.ago)

        visit tincanz.admin_conversation_path(conv)

        assert_seen(conv.subject)

        messages = Nokogiri::HTML(page.body).css(".messages-list .content").map(&:text).map(&:strip)
        expect(messages).to eq [message_a.content, message_b.content]
      end
    end

    context "creating a reply" do
      it 'is valid with content' do
        conv = create(:conversation)

        visit tincanz.admin_conversation_path(conv)

        within('.conversation-reply') do
          fill_in 'Content', with: 'coming atcha!'
          click_button 'Reply'
        end

        flash_notice!('Your message was delivered.')
        assert_seen 'coming atcha!', within: :first_message
      end

      it "is invalid with no content" do
        conv = create(:conversation)

        visit tincanz.admin_conversation_path(conv)

        within('.conversation-reply') do
          click_button 'Reply'
        end

        flash_alert!('Could not create your message.')
        expect(page).to_not have_content 'coming atcha!'
      end
    end
  end
end