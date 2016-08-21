FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password 'secret_password'
    password_confirmation 'secret_password'
  end
end
