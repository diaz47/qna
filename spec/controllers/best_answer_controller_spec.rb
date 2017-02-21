require 'rails_helper'

RSpec.describe BestAnswerController, type: :controller do
  describe 'PATCH #update' do
    let(:prev_answer){ create(:answer, best_answer: true, question: question) }
    let(:answer){ create(:answer, question: question) }
    let(:question){ create(:question, user: @user) }
    
    context 'Author try select best answer' do
      sign_in_user

      before { patch :update, question_id: question, id: answer }

      it 'assign to requiest question' do
        expect(assigns(:question)).to eq question
      end

      it 'assign to requiest answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'change attribute for answer and prev-answer' do
        answer.reload
        prev_answer.reload

        expect(answer.best_answer).to eq true
        expect(prev_answer.best_answer).to eq false
      end

      it 'redirect to question' do
        expect(response).to redirect_to question
      end
    end

    context 'No Author try select best answer' do
      sign_in_user
      let(:question){ create(:question) }

      before { patch :update, question_id: question, id: answer }

      it 'not change attribute for answer and prev-answer' do
        answer.reload
        prev_answer.reload

        expect(answer.best_answer).to eq false
        expect(prev_answer.best_answer).to eq true
      end
    end
  end
end