class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def set_best_answer
    question = self.question
    question.answers.where.not(id: self).update_all(best_answer: false)
    self.best_answer = true
    self.save!
  end
end
