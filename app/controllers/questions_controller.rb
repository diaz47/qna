class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy, :update]
  before_action :set_question, only: [:show, :destroy, :update]
  before_action :build_answer, :load_answers, only: [:show]
  after_action :publish_question, only: [:create]
  respond_to :html
  authorize_resource
  include VoteFor

  def index
    respond_with (@questions = Question.all)
  end

  def show
    @comment = Comment.new
  end

  def new
    respond_with (@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(questions_params))
  end

  def destroy
    respond_with(@question.destroy)
  end

  def update
    @question.update(questions_params)
    respond_with @question
  end

  private
  def set_question
    @question = Question.find(params[:id])
  end

  def questions_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :_destroy, :id])
  end

  def build_answer
    @answer = @question.answers.build    
  end

  def load_answers
    @answers = @question.answers.best_answer_show_first    
  end
  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast 'questions', ApplicationController.render( 
      partial: 'questions/question', 
      locals: { question: @question}
    )
  end
end
