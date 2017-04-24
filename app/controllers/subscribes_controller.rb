class SubscribesController < ApplicationController
  before_action :set_question, only: [:destroy, :create]

  authorize_resource

  def create
    @subscribe = @question.subscribes.create(user: current_user) if !@question.subscribes.exists?(user_id: current_user.id)
    respond_with @question
  end

  def destroy
    @subscriber = @question.subscribes.where(user_id: current_user.id).first.destroy if @question.subscribes.exists?(user_id: current_user.id)
    respond_with @question
  end

  private
  def set_question
    @question = Question.find(params[:id])
  end
end
