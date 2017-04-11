class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: [:index, :create]

  authorize_resource
  
  def index
    @answers = @question.answers
    respond_with @answers
  end

  def show
    @answers = Answer.find(params[:id])
    respond_with @answers, serializer: FullAnswerSerializer
  end

  def create
    @answer = @question.answers.create(answers_params.merge(user: current_resource_owner))
    respond_with @answer
  end

  private
  def answers_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end