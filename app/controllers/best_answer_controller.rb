class BestAnswerController < ApplicationController
  def update
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])
    
    if current_user.author_of?(@question)
      @question.answers.where.not(id: @answer.id).update_all(best_answer: false)
      @answer.best_answer = true
      @answer.save!
      redirect_to @question, notice: "Best asnwer was selected"
    else
      redirect_to @question, notice: "ERROR"
    end
  end
end