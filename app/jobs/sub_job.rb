class SubJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscribers.each do |sub|
      SubscriberMailer.question_mail(sub.user.email, answer).deliver_later
    end
  end
end
