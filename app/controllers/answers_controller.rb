class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:destroy, :update]


  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    if @answer.save
      flash[notice] = "Your answer successfully created"
    else
      flash[notice] = "Error"
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

  def update
    @question = @answer.question
    if current_user.author_of?(@answer) 
      @answer.update(answer_params)
    end
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
