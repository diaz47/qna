class AddQuestionIdToAnswer < ActiveRecord::Migration[5.0]
  def change
    add_reference :answers, :question
  end
end
