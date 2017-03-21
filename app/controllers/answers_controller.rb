class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update]
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:destroy, :update, :select_best_answer]

  include VoteFor

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
      flash[:notice] = "Your answer was success deleted"
    else
      flash[:notice] = "You cannot delete this answer"
    end
  end

  def update
    @question = @answer.question
    if current_user.author_of?(@answer) && @answer.update(answer_params)
      flash[:notice] = 'Answer was success updated'
    else
      flash[:notice] = 'ERROR'
    end
  end

  def select_best_answer
    @question = @answer.question
    
    if current_user.author_of?(@question)
      @answer.set_best_answer
      redirect_to @question, notice: "Best asnwer was selected"
    else
      redirect_to @question, notice: "ERROR"
    end
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
end
