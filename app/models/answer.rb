class Answer < ApplicationRecord
  has_many :votes, as: :votable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :question, touch: true
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy


  validates :body, presence: true

  after_commit :notificate_subscribers

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  scope :best_answer_show_first, -> { order(best_answer: :desc) }

  def set_best_answer
    self.question.answers.where.not(id: self).update_all(best_answer: false)
    self.update!(best_answer: true)
  end

  private
  def notificate_subscribers
    SubJob.perform_later(self)
  end
end
