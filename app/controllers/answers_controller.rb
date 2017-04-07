class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update]
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:destroy, :update, :select_best_answer]
  before_action :new_comment, only: [:create, :update]
  before_action :get_question, only: [:update, :select_best_answer]
  after_action :publish_answer, only: [:create]
  respond_to :js

  authorize_resource
  
  include VoteFor

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def select_best_answer
    @answer.set_best_answer 
    respond_with @question
  end

  private
  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :_destroy, :id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def get_question
    @question = @answer.question
  end
  def new_comment
    @comment = Comment.new
  end

  def publish_answer
    return if @answer.errors.any?
    attachments = @answer.attachments.map(&:attributes)
    ActionCable.server.broadcast("answer_question_#{@answer.question_id}", 
      answer: @answer, 
      question: @question, 
      attachments: attachments,
      rating: @answer.votes.sum(:value)
    )
  end
end
