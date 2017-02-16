class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:destroy]


  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    if @answer.save
      redirect_to @question, notice: "Your answer successfully created"
    else
      @answers = @question.answers.all
      render "questions/show"
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      notice = "Your answer was success deleted"
    else
      notice = "You cannot delete this answer"
    end
    redirect_to question_path(params[:question_id]), notice: notice
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

end
