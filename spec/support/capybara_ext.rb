module CapybaraExt
  # login helper
  def sign_in(user)
    page.driver.post "/users/sign_in", :user => {
      :email => user.email, :password => user.password
    }
  end

  def sign_out
    page.driver.delete "/users/sign_out"
  end

  # Just a shorter way of writing it.
  def assert_seen(text, opts={})
    if opts[:within]
      within(selector_for(opts[:within])) do
        expect(page).to have_content(text)
      end
    else
      expect(page).to have_content(text)
    end
  end

  def assert_not_seen(text, opts={})
    if opts[:within]
      within(selector_for(opts[:within])) do
        expect(page).to_not have_content(text)
      end
    else
      expect(page).to_not have_content(text)
    end
  end

  def flash_alert!(text)
    within(".alert") do
      assert_seen(text)
    end
  end

  def flash_notice!(text)
    within(".notice") do
      assert_seen(text)
    end
  end

  def selector_for(identifier)
    case identifier
    when :first_conversation then '.conversations-list .conversation:nth-child(1)'
    when :conversation_message then '.conversation-message'
    when :first_reply then '.replies-list .message:nth-child(1)'
    when :second_reply then '.replies-list .message:nth-child(2)'
    when :first_user then '.users-list .user:nth-child(1)'
    when :second_user then '.users-list .user:nth-child(2)'
    when :recipients_list then '.recipients-list'
    else
      raise "**** You specified to search within #{identifier}, but you haven't defined it in spec/support/capybara_ext.rb ****"
    end
  end

  # Just shorter to type.
  def page!
    save_and_open_page
  end
end

RSpec.configure do |config|
  config.include CapybaraExt, :type => :feature
end
