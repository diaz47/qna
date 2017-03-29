class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :set_commentable, only: [:create]
  after_action :publish_comment, only: [:create]

  def create
    Rails.logger.info "Get commentable #{@commentable}"
    @comment = @commentable.comments.new(comment_params.merge(user: current_user))
    if @comment.save
      render json: { body: @comment.body, commentable_id: @commentable.id, commentable_type: @commentable.class.to_s.downcase } 
    else
      render json: @comment.errors.full_messages, status: 422 
    end
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
