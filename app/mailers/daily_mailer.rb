class DailyMailer < ApplicationMailer
  default from: 'from@example.com'

  def digest(user, questions)
    @greeting = 'Hi'

    mail to: user.email
    mail body: questions.map { |question| question.title }.join(',')
    mail subject: 'Daily Quetions'
  end
end
