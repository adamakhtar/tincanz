FactoryGirl.define do
  factory :user do |f|
    f.email { "bob#{rand(100000)}@boblaw.com" }
    f.password "password"
    f.password_confirmation "password"
    f.admin false
    
    factory :admin do |a|
      a.admin true
    end
  end
end

