class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy, :update]
  before_action :set_question, only: [:show, :destroy, :update]
  before_action :set_vote_data, only: [:vote, :delete_vote]

  def vote
    @vote = @question.votes.new(value: params[:value], user_id: current_user.id)
    @user = @question.votes.find_by user_id: @vote_user.id
    if @user.nil? && !current_user.author_of?(@question)
      @vote.save!
      flash[:notice] = "You successfully voted"
    else
      flash[:notice] = "You cannot voted"
    end
    redirect_to @question
  end

  def delete_vote
    @vote = @question.votes.find_by user_id: @vote_user.id
    if !@vote.nil?
      @vote.destroy 
      flash[:notice] = "You successfully reset vote"
    end
    
    redirect_to @question
  end

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

  def set_vote_data
    @question = Question.find(params[:question_id])
    @vote_user = User.find(params[:user_id])
  end
  
end
