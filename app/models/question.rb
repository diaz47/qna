class Question < ApplicationRecord
  has_many :votes, as: :votable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :answers, dependent: :destroy
  has_many :subscribes, dependent: :destroy
  has_many :subscribers, through: :subscribes, source: :user
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user


  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :subscribe_author


  private
  def subscribe_author
    subscribes.create(user: user)
  end
end
