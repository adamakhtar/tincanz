FactoryGirl.define do
  factory :message, class: Tincanz::Message do |f|
    user
    content "Hi how are you?"

    after :create do |m|
      m.recipients = [create(:user)] unless m.recipients.present?
    end
  end
end

