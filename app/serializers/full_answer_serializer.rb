class FullAnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at
  has_many :comments
  has_many :attachments, serializer: AttachmentSerializer
end
