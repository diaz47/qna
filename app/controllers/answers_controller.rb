class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update]
  before_action :set_question, only: [:create, :destroy]
  before_action :set_answer, only: [:destroy, :update, :select_best_answer]
  before_action :set_vote_data, only: [:vote, :delete_vote]

  def vote
    @vote = @answer.votes.new(value: params[:value], user_id: current_user.id)
    @user = @answer.votes.find_by user_id: @vote_user.id
    if @user.nil? && !current_user.author_of?(@answer)
      @vote.save!
      flash[:notice] = "You successfully voted"
    else
      flash[:notice] = "You cannot voted"
    end
    redirect_to @answer.question
  end

  def delete_vote
    @vote = @answer.votes.find_by user_id: @vote_user.id
    if !@vote.nil? && !current_user.author_of?(@answer)
      @vote.destroy 
      flash[:notice] = "You successfully reset vote"
    end
    redirect_to @answer.question
  end

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

  def set_vote_data
    @answer = Answer.find(params[:answer_id])
    @vote_user = User.find(params[:user_id])
  end

end
