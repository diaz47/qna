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

    it 'build new attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assign a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'build new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
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

  describe 'PATCH #update' do
    context 'Author update' do
      sign_in_user
      let(:question) { create(:question, user: @user) }
      context 'with valid data' do
        it 'assign the requiest question' do
          patch :update, id: question, question: attributes_for(:question), format: :js
          expect(assigns(:question)).to eq question
        end

        it 'change attributes in question' do
          patch :update, id: question, question: {title: "My new title", body: "My new body"}, format: :js
          question.reload

          expect(question.title).to eq 'My new title'
          expect(question.body).to eq 'My new body'
        end

        it 'render template' do
          patch :update, id: question, question: attributes_for(:question), format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid data' do
        it 'not change attributes' do
          patch :update, id: question, question: {title: "", body: "My new body"}, format: :js
          question.reload

          expect(question.body).to_not eq 'My new body'
        end
      end
    end

    context 'No Author try update' do
      let(:question) { create(:question) }
      it 'not change attributes' do
        patch :update, id: question, question: {title: "Tratata", body: "My new body"}, format: :js
        question.reload

        expect(question.title).to_not eq 'Tratata'
        expect(question.body).to_not eq 'My new body'
      end
    end
  end

  describe 'POST #vote' do
    context 'Author of question try vote for question' do
      sign_in_user
      let(:question) { create(:question, user: @user) }

      it 'rating no change' do
        expect { post :vote, user_id: @user.id, id: question.id, value: 1, format: :js }.to_not change(question.votes, :count)
      end

      it 'render to question' do
        post :vote, user_id: @user.id, id: question.id, value: 1, format: :js
        expect(response).to render_template :vote
      end
    end
    

    context 'No Author of question try vote for question' do 
      sign_in_user
      let(:question) { create(:question) }

      it 'rating change' do
        expect { post :vote, user_id: @user.id, id: question.id, value: 1, format: :js }.to change(question.votes, :count)
      end

      it 'render to question' do
        post :vote, user_id: @user.id, id: question.id, value: 1, format: :js
        expect(response).to render_template :vote
      end
    end
  end

  context 'POST #delete_vote' do 
    context 'No author of question try reset vote' do
      sign_in_user
      let(:question) { create(:question) }
      let!(:vote_user) { create(:vote, user: @user, votable: question) }

      it 'rating reset' do
        vote_user
        expect { post :delete_vote, user_id: @user.id, id: question.id, format: :js }.to change(question.votes, :count)
      end

      it 'render to question' do
        post :delete_vote, user_id: @user.id, id: question.id, format: :js
        expect(response).to render_template :delete_vote
      end
    end
    
    context 'Author of question try reset vote' do 
      sign_in_user
      let(:question) { create(:question, user: @user) }

      it 'rating no change' do
        expect { post :delete_vote, user_id: @user.id, id: question.id, value: 1 , format: :js}.to_not change(question.votes, :count)
      end

      it 'render to question' do
        post :delete_vote, user_id: @user.id, id: question.id, value: 1, format: :js
        expect(response).to render_template :delete_vote
      end
    end
  end
end
