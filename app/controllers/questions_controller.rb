class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :set_question, only: [:show, :destroy, :check_question_author]
  before_action :check_question_author, only: :destroy
  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answers = @question.answers.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(questions_params)
    if @question.save
      redirect_to @question, notice: "Your question successfully created"
    else
      render :new
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: "Your question was deleted"
  end

  private
  def set_question
    @question = Question.find(params[:id])
  end

  def questions_params
    params.require(:question).permit(:title, :body)
  end
  
  def check_question_author
    unless current_user.id == @question.user_id
      flash[:notice] = "You cannot delete this question"
      redirect_to @question
    end
  end
end
