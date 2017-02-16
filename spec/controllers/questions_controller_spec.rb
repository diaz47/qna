require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  describe 'GET #index' do 
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render :index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assign request question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'should assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render :show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assign a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render :new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid data' do
      it 'save new question in db' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'sets user_id equal to the curent user' do
        post :create, params: {question: attributes_for(:question)}
        expect(assigns(:question).user).to eq @user
      end

      it 'redirect to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid data' do
      it 'do not save in db' do
        expect { post :create, question: attributes_for(:ivalid_question) }.to_not change(Question, :count)
      end

      it 'render :new view' do
        post :create, question: attributes_for(:ivalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let(:question) {create(:question, user: @user)}
    context 'Author question' do
      it 'delete question from the db' do
        question
        expect { delete :destroy, id: question }.to change(Question, :count).by(-1) 
      end
      it 'redirect to questions path' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context 'No Author' do
      sign_in_user
      let(:question) { create(:question) }
      it 'delete question from the db' do
        question
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end
      it 'redirect to questions path' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end
  end
end
