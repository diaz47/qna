module VoteFor
  extend ActiveSupport::Concern

  included do
    before_action :set_data_for_vote, only: [:vote, :delete_vote]
  end

  def vote
    @vote = @element.votes.new(value: params[:value] == 'yes' ? 1 : -1, user_id: current_user.id)
    @user = @element.votes.find_by(user_id: current_user.id)
    if @user.nil? && !current_user.author_of?(@element)
      @vote.save!
      flash[:notice] = "You successfully voted"
    else
      flash[:notice] = "You cannot voted"
    end
  end

  def delete_vote
    @vote = @element.votes.find_by(user_id: current_user.id)
    if !@vote.nil?
      @vote.destroy 
      flash[:notice] = "You successfully reset vote"
    end
  end

  private
  def model_klass
    controller_name.classify.constantize
  end

  def set_data_for_vote
    @element = model_klass.find(params[:id])
  end
end