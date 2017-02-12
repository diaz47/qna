require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    sign_in_user
    let(:question) { create(:question) }

    context 'with valid data' do
      it 'save new answer in db' do
        expect { post :create, answer: attributes_for(:answer), question_id: question }.to change(question.answers, :count).by(1)
      end

      it 'redirect to question :show' do
        post :create, answer: attributes_for(:answer), question_id: question
        expect(response).to redirect_to question
      end
    end

    context 'with invalid data' do 
      it 'do not save answer in db' do
        expect { post :create, answer: attributes_for(:invalid_answer), question_id: question }.to_not change(question.answers, :count)
      end
      
      it 'redirect to question :show' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question
        expect(response).to redirect_to question
      end
    end
  end
end
