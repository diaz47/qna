require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid data' do
      let(:answer) { create(:answer, user: @user)}

      it 'save new answer in db' do
        expect { post :create, answer: attributes_for(:answer), question_id: question, format: :js }.to change(Answer, :count).by(1)
      end

      it 'sets user_id equal to the curent user' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer).user).to eq @user
      end

      it 'sets question_id equal to the curent question' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer).question).to eq question
      end

      it 'render create template' do
        post :create, answer: attributes_for(:answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid data' do 
      it 'do not save answer in db' do
        expect { post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js }.to_not change(Answer, :count)
      end
      
      it 'render template create' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'Author try delete' do
      let!(:answer) { create(:answer, user: @user, question: question)}
      it 'delete answer from the db' do
        expect{ delete :destroy, id: answer, question_id: question }.to change(Answer, :count).by(-1)
      end
      it 'redirects to question show view' do
        delete :destroy, question_id: question, id: answer
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'No Author try delete' do
      let!(:answer) { create(:answer, question: question)}
      it 'not delete answer from the db' do
        expect{ delete :destroy, id: answer, question_id: question }.to_not change(Answer, :count)
      end
      it 'redirect to question path' do
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end
end
