module VoteFor
  extend ActiveSupport::Concern

  def vote
    @question = Question.find(question_id: params[:question_id])
    @vote = Vote.find(user_id: params[:user_id])

    if @vote.user_id != current_user.id
      @vote.increment!(:value)
      @vote.save!
    end
  end
end