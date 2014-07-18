describe 'admin::users', type: :feature do
  let(:admin){ create(:admin) }
  
  it 'lists all users' do
    user_a = create(:user)
    user_b = create(:user)

    sign_in admin

    visit tincanz.admin_users_path
    
    user_emails = Nokogiri::HTML(page.body).css(".users-list tr td.email").map(&:text)
    expect(user_emails.size).to eq 3
  end
end