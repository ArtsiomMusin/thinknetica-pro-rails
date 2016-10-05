class AnswerMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.answer_mailer.digest.subject
  #
  def digest(user)
    @greeting = "Hi"

    mail to: user.email
    mail subject: 'Got a new answer!'
  end
end
