class Answer < ApplicationRecord
  has_many :votes, as: :votable, dependent: :destroy

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  scope :best_answer_show_first, -> { order(best_answer: :desc) }

  def set_best_answer
    self.question.answers.where.not(id: self).update_all(best_answer: false)
    self.update!(best_answer: true)
  end
end
