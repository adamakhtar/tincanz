require "rails_helper"

describe 'admin::assignees', type: :feature do
  
  let(:admin){ create(:admin) }
  
  context "signed in as admin" do

    before do
      sign_in admin
    end

    it "updates assignee" do
      conv = create(:conversation)
      msg  = create(:message, conversation: conv)
      other_admin = create(:admin)

      visit tincanz.conversation_path(conv)
      page.select other_admin.tincanz_email, from: 'conversation_user_id'
      click_button 'Update' 

      flash_notice!('Conversation was assigned.')
    end
  end

end