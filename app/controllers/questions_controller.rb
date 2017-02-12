class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :set_question, only: [:show, :destroy]

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
      flash[:notice] = "Your question successfully created"
      redirect_to @question
    else
      render :new
    end
  end

  def destroy
    if current_user.id == @question.user_id
      @question.destroy
      flash[:notice] = "Your question was deleted"
      redirect_to questions_path
    else
      flash[:notice] = "You cannot delete this question"
      redirect_to @question
    end
  end

  private
  def set_question
    @question = Question.find(params[:id])
  end

  def questions_params
    params.require(:question).permit(:title, :body)
  end
end
