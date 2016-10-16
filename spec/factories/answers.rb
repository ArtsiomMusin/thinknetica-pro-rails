FactoryGirl.define do
  factory :answer do
    body 'AnswerText'
    question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end

  factory :best_answer, class: 'Answer' do
    body 'AnswerText'
    question
    user
    best true
  end
end
