FactoryGirl.define do
  factory :conversation, class: Tincanz::Conversation do |f|
    subject "Hi there"
    user
  end
end

