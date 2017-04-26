class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where("created_at < ?", 1.days.ago)

    mail to: user.email
  end
end
