class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:destroy, :check_answer_author]
  before_action :check_answer_author, only: [:destroy]


  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    if @answer.save
      redirect_to @question, notice: "Your answer successfully created"
    else
      render :new
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_path(params[:question_id]), notice: 'Your answer was success deleted'
  end

  private
  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def check_answer_author
    unless current_user.id == @answer.user_id
      flash[:notice] = "You cannot delete this question"
      redirect_to question_path(params[:question_id])
    end
  end
end
