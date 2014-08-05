require "rails_helper"

describe 'admin::messages', type: :feature do

    let(:admin) { create(:admin) }
    let(:conv)  { create(:conversation, first_message: create(:message)) }


    context "creating a reply" do      
      before do 
        sign_in admin
        visit tincanz.conversation_path(conv)

        within(selector_for(:conversation_message)) do
          click_link 'Reply'
        end
      end

      it 'is valid with content and quotes previous message' do
        expect(page.current_path).to eq tincanz.new_conversation_message_path(conv)
        fill_in 'Content', with: 'coming atcha!'
        click_button 'Send'
        
        expect(page.current_path).to eq tincanz.conversation_path(conv)       
        flash_notice! ('Your reply was delivered.')
        assert_seen 'coming atcha!'
        assert_seen conv.first_message.content
      end

      it "is invalid with no content" do
        expect(page.current_path).to eq tincanz.new_conversation_message_path(conv)
        fill_in 'Content', with: '' # remove quoted reply
        click_button 'Send'
        flash_alert!('Could not create your reply.')
        expect(page).to_not have_content 'coming atcha!'
      end
    end
  

end