require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:answer) { create(:answer) }
  let(:answer_user) { create(:answer, user: user) }
  describe 'POST #create' do
    sign_in_user

    context 'with valid data' do
      it 'save new answer in db' do
        expect { post :create, answer: attributes_for(:answer), question_id: question }.to change(Answer, :count).by(1)
      end

      it 'redirect to question :show' do
        post :create, answer: attributes_for(:answer), question_id: question
        expect(response).to redirect_to question
      end
    end

    context 'with invalid data' do 
      it 'do not save answer in db' do
        expect { post :create, answer: attributes_for(:invalid_answer), question_id: question }.to_not change(Answer, :count)
      end
      
      it 'redirect to question :show' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    context 'Author try delete' do
      it 'answer id == user id' do
        expect(answer_user.user_id).to eq user.id
      end
      it 'delete answer from the db' do
        expect { delete :destroy, id: answer_user, question_id: question, user_id: user }.to change(Answer, :count).by(-1) 
      end
      it 'redirect to questions path' do
        delete :destroy, id: answer_user, question_id: question
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'No Author try delete' do
      it 'answer id != user id' do
        expect(answer.user_id).to_not eq user.id
      end
      it 'delete answer from the db' do
        expect { delete :destroy, id: answer, question_id: question, user_id: user}.to change(Answer, :count).by(0) 
      end
      it 'redirect to question path' do
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
