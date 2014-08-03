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
      msg_a  = create(:message, conversation: conv_a, user: admin, recipients: [create(:user)])
      conv_b = create(:conversation)
      msg_b  = create(:message, conversation: conv_b, user: admin, recipients: [create(:user)])

      visit tincanz.admin_conversations_path
      
      conversations = Nokogiri::HTML(page.body).css(".conversations-list .conversation").map(&:text)
      expect(conversations.size).to eq 2
    end

    context 'when displaying a conversation' do
      before do 
        @conv        = create(:conversation)
        @message     = create(:message, content: 'hi', conversation: @conv, created_at: 4.days.ago)
        @recipient_a = create(:user)
        @recipient_b = create(:user)
        @message.recipients << [@recipient_a, @recipient_b]

        @reply_a = create(:message, reply_to: @message, user: @recipient_a, content: 'hows it going?', conversation: @conv, created_at: 3.days.ago)
        @reply_b = create(:message, reply_to: @message, content: 'pretty good',    conversation: @conv, created_at: 2.days.ago)
      end

      it 'displays message recipients' do
        visit tincanz.admin_conversation_path(@conv)
        within(selector_for :conversation_message) do

        end
        assert_seen @recipient_a.tincanz_email, within: :conversation_message
        assert_seen @recipient_b.tincanz_email, within: :conversation_message
      end

      it 'displays first message' do
        visit tincanz.admin_conversation_path(@conv)
        assert_seen @message.content, within: :conversation_message
        assert_seen @message.recipients.first.tincanz_email
      end

      it 'shows replies' do
        visit tincanz.admin_conversation_path(@conv)
        messages = Nokogiri::HTML(page.body).css(".conversation-replies .content").map(&:text).map(&:strip)
        expect(messages).to eq [@reply_a.content, @reply_b.content]
      end
    end


    context "creating a new conversaton with single recipient" do

      before do
        sign_in admin
        user = create(:user)

        visit tincanz.admin_users_path
        within(selector_for(:first_user)) do
          click_link 'message'
        end
      end

      it 'is valid with content' do
        fill_in 'Content', with: 'blahblahblah'
        click_button 'Send'

        expect(page.current_path).to eq tincanz.admin_conversation_path(Tincanz::Conversation.last)
        flash_notice! 'Your message was delivered.'
        assert_seen 'blahblahblah', within: :conversation_message
      end

      it 'is not valid without content' do
        click_button 'Send'
        flash_alert!('Could not create your message.')
      end

    end
      
    context "creating a new conversaton with multiple recipients" do

      before do
        sign_in admin
        @user_a = create(:user)
        @user_b = create(:user)

        visit tincanz.admin_users_path
        
        find("#user_#{@user_a.id} input[type='checkbox']").set(true)
        find("#user_#{@user_b.id} input[type='checkbox']").set(true)
        
        within('.multi-actions') do
          click_button 'Message'
        end
      end

      it "creates a message" do
        fill_in 'Content', with: 'blahblahblah'
        click_button 'Send'

        expect(page.current_path).to eq tincanz.admin_conversation_path(Tincanz::Conversation.last)
        flash_notice! 'Your message was delivered.'

        within(selector_for(:conversation_message)) do
          expect(page).to have_content 'blahblahblah'
          assert_seen @user_a.tincanz_email, within: :recipients_list
          assert_seen @user_b.tincanz_email, within: :recipients_list
        end
      end
    end
    

    context "creating a reply" do

      let(:conv) { create(:conversation, first_message: create(:message)) }

      before do 
        visit tincanz.admin_conversation_path(conv)

        within(selector_for(:conversation_message)) do
          click_link 'Reply'
        end
      end

      it 'is valid with content and quotes previous message' do
        expect(page.current_path).to eq tincanz.new_admin_conversation_message_path(conv)
        fill_in 'Content', with: 'coming atcha!'
        click_button 'Send'
        
        expect(page.current_path).to eq tincanz.admin_conversation_path(conv)       
        flash_notice! ('Your reply was delivered.')
        assert_seen 'coming atcha!'
        assert_seen conv.first_message.content
      end

      it "is invalid with no content" do
        expect(page.current_path).to eq tincanz.new_admin_conversation_message_path(conv)
        fill_in 'Content', with: '' # remove quoted reply
        click_button 'Send'
        flash_alert!('Could not create your reply.')
        expect(page).to_not have_content 'coming atcha!'
      end
    end
  end
end