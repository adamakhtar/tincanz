describe 'admin::conversations', type: :feature do
  let(:admin){ create(:admin) }
  
  it 'lists all conversations' do
    
    conv_a = create(:conversation)
    conv_b = create(:conversation)

    sign_in admin

    visit tincanz.admin_conversations_path
    
    conversations = Nokogiri::HTML(page.body).css(".conversations-list .subject").map(&:text)
    expect(conversations.size).to eq 2
  end
end