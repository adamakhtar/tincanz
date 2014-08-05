require "rails_helper"

describe 'admin::users', type: :feature do
  let(:admin){ create(:admin) }

  context "signed in as normal user" do
    it 'redirects to root path' do
      sign_in create(:user)
      visit tincanz.users_path
      assert_unauthorized
    end
  end
  
  context "signed in as admin" do

    before do
      sign_in admin
    end
  
    it 'lists all users' do
      user_a = create(:user)
      user_b = create(:user)

      sign_in admin

      visit tincanz.users_path
      
      user_emails = Nokogiri::HTML(page.body).css(".users-list tr td.email").map(&:text)
      expect(user_emails.size).to eq 3
    end

    it 'displays user' do
      user = create(:user)
      sign_in admin

      visit tincanz.users_path

      click_link user.tincanz_email

      expect(page.current_path).to eq tincanz.user_path(user)

      assert_seen(user.email)
    end
  end
end