class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "answer_question_#{data['id']}"
  end
end