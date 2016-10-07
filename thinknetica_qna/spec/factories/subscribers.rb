FactoryGirl.define do
  factory :subscriber do
    user_id { create(:user).id }
  end
end
