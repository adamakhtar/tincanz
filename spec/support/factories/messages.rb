FactoryGirl.define do
  factory :message, class: Tincanz::Message do |f|
    conversation
    user
    content "Hi how are you?"
  end
end

