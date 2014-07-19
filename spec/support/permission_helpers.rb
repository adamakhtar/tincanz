module PermissionHelpers
  def assert_unauthorized
    flash_alert!("Sorry you can't access that.")
    expect(page.current_path).to eq root_path
  end
end

RSpec.configure do |c|
  c.include PermissionHelpers, :type => :feature
end
