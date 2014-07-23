require "rails_helper"

describe 'admin::messages', type: :feature do
  
  let(:admin){ create(:admin) }

  context "creating new conversation" do

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
end