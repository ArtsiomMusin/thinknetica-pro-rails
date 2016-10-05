class DailyMailer < ApplicationMailer
  def digest(user, questions)
    @greeting = 'Hi'
    mail to: user.email
    mail subject: 'Daily Quetions'
    mail body: questions.map { |question| question.title }
  end
end
