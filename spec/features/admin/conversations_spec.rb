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

  it 'displays conversation' do
    conv = create(:conversation)
    message_a = create(:message, content: 'fiz', conversation: conv, created_at: 1.days.ago)
    message_b = create(:message, content: 'buz', conversation: conv, created_at: 10.days.ago)

    sign_in admin

    visit tincanz.admin_conversation_path(conv)

    assert_seen(conv.subject)
    page!
    messages = Nokogiri::HTML(page.body).css(".messages-list .content").map(&:text).map(&:strip)
    expect(messages).to eq [message_a.content, message_b.content]
  end
end