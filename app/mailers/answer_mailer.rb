class AnswerMailer < ApplicationMailer
  default from: 'from@example.com'

  def digest(user)
    @greeting = "Hi"
    
    mail to: user.email
    mail subject: 'Got a new answer!'
  end
end
