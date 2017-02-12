class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    @question = Question.find(params[:question_id])

    @answer = @question.answers.new(answer_params.merge(user: current_user))
    if @answer.save
      flash[:notice] = "Your answer successfully created"
      redirect_to @question
    else
      flash[:notice] = " Your answer must contain text"
      redirect_to @question
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.id == @answer.user_id
      @answer.destroy
      flash[:notice] = 'Your answer was success deleted'
      redirect_to question_path(params[:question_id])
    else
      flash[:notice] = 'You cannot delete this questions'
      redirect_to question_path(params[:question_id])
    end
  end

  private
  def answer_params
    params.require(:answer).permit(:body)
  end
end
