FactoryGirl.define do
  factory :subscription do
    user_id { create(:user).id }
  end
end
