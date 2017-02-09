class QuestionsController < ApplicationController
  before_action :set_question, only: :show

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
    @question = Question.new(questions_params)
    if @question.save
      redirect_to @question
    else
      render :new
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
