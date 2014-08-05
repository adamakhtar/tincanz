require "rails_helper"

describe 'Conversations', type: :feature do
  
  let!(:admin){ create(:admin) }
  let!(:user){ create(:user) }

  context "signed in as user" do

    before do
      sign_in user
    end

    context "creating a reply to conversation" do

      it "is valid with content" do
        msg  = create(:message, user: admin, recipients: [user])
        conv = create(:conversation, messages: [msg])

        visit tincanz.conversation_path(conv)

        within(selector_for(:conversation_message)) do
          click_link 'Reply'
        end

        fill_in 'Content', with: 'woohoo'
        click_button 'Send'

        expect(page.current_path).to eq(tincanz.conversation_path(conv))
        flash_notice!('Your reply was delivered.')
      end

      it "is invalid with no content" do
        msg  = create(:message, user: admin, recipients: [user])
        conv = create(:conversation, messages: [msg])

        visit tincanz.conversation_path(conv)

        within(selector_for(:conversation_message)) do
          click_link 'Reply'
        end

        fill_in 'Content', with: ''
        click_button 'Send'

        flash_alert!('Could not create your reply.')
      end
    end
  end
end