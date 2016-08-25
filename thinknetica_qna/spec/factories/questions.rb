FactoryGirl.define do
  factory :question do
    title 'MyTitle'
    body 'MyBody'
    user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
