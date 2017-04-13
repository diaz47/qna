class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :file_url

  def file_url
    object.file.url
  end
end
