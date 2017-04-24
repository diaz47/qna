class SubscriberMailer < ApplicationMailer
  def question_mail(email, answer)
    @answer = answer
    @question = answer.question

    mail to: email, subject: 'Question notify'
  end
end
