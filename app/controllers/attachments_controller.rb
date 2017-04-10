class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attachments, only: [:destroy]
  respond_to :js
  authorize_resource
  
  def destroy
    respond_with @attachment.destroy
  end

  private
  def set_attachments
    @attachment = Attachment.find(params[:id])
  end
end
