class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy, :update]
  before_action :set_question, only: [:show, :destroy, :update]

  include VoteFor

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
    @answers = @question.answers.best_answer_show_first
  end

  def new
    @question = Question.new
    @question.attachments.build
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
    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = "Your question was deleted"
    else
      flash[:notice] = "You cannot delete this question"
    end
    redirect_to questions_path
  end

  def update
    if current_user.author_of?(@question)
      @question.update(questions_params)
    end
  end

  private
  def set_question
    @question = Question.find(params[:id])
  end

  def questions_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :_destroy, :id])
  end

  
end
