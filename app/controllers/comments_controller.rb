class CommentsController < ApplicationController
  before_action :authenticate_user!, :set_commentable, only: [:create]
  after_action :publish_comment, only: [:create]

  respond_to :json, only:[:create]

  authorize_resource
  
  def create
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
    respond_with(@comment, location: @commentable)
  end

  private
  def comment_params
    params.require(:comment).permit(:body, :commentable_type, :commentable_id)
  end
  def set_commentable
    commentable_type = params[:comment][:commentable_type].classify.constantize
    commentable_id =  params[:comment][:commentable_id]
    @commentable = commentable_type.find(commentable_id)
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast('comments', comment: @comment)
  end
end
