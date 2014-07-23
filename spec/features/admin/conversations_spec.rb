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

    it 'lists all' do
      conv_a = create(:conversation)
      conv_b = create(:conversation)

      visit tincanz.admin_conversations_path
      
      conversations = Nokogiri::HTML(page.body).css(".conversations-list .subject").map(&:text)
      expect(conversations.size).to eq 2
    end

    context 'displaying instance' do
      before do 
        @conv = create(:conversation)
        @message = create(:message, content: 'hi', conversation: @conv, created_at: 4.days.ago)

        @reply_a = create(:message, reply_to: @message, content: 'hows it going?', conversation: @conv, created_at: 3.days.ago)
        @reply_b = create(:message, reply_to: @message, content: 'pretty good',    conversation: @conv, created_at: 2.days.ago)
      end

      it 'displays first message' do
        visit tincanz.admin_conversation_path(@conv)
        assert_seen @message.content, within: :conversation_message
      end

      it 'shows replies' do
        visit tincanz.admin_conversation_path(@conv)
        messages = Nokogiri::HTML(page.body).css(".conversation-replies .content").map(&:text).map(&:strip)
        expect(messages).to eq [@reply_a.content, @reply_b.content]
      end
    end

    context "creating a reply" do
      it 'is valid with content' do
        conv = create(:conversation, first_message: create(:message))

        visit tincanz.admin_conversation_path(conv)

        within('.conversation-reply') do
          fill_in 'Content', with: 'coming atcha!'
          click_button 'Reply'
        end
        flash_notice!('Your message was delivered.')
        assert_seen 'coming atcha!', within: :first_reply
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