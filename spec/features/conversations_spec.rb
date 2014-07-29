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
  end
end