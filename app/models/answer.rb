class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :best_answer_show_first, -> { order(best_answer: :desc) }

  def set_best_answer
    self.question.answers.where.not(id: self).update_all(best_answer: false)
    self.update!(best_answer: true)
  end
end
