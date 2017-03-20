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
        expect{ delete :destroy, id: answer, question_id: question, format: :js}.to change(Answer, :count).by(-1)
      end
      it 'render template' do
        delete :destroy, id: answer, question_id: question, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'No Author try delete' do
      let!(:answer) { create(:answer, question: question)}
      it 'not delete answer from the db' do
        expect{ delete :destroy, id: answer, question_id: question, format: :js }.to_not change(Answer, :count)
      end
      it 'render template' do
        delete :destroy, id: answer, question_id: question, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'Author try update' do
      let!(:answer) { create(:answer, question: question, user: @user) }
      it 'assings the requested answer to @answer' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns th question' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes answer attributes' do
        patch :update, id: answer, question_id: question, answer: { body: 'new body'}, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'render update template' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end
    end

    context 'No Author try update' do
      let!(:answer) { create(:answer, question: question)}
      it 'not cahnge answer' do
        patch :update, id: answer, question_id: question, answer: { body: 'new body'}, format: :js
        answer.reload
        expect(answer.body).to_not eq "new body"
      end
    end
  end

  describe 'PATCH #select_best_answer' do
    let(:prev_answer){ create(:answer, best_answer: true, question: question) }
    let(:answer){ create(:answer, question: question) }
    
    
    context 'Author try select best answer' do
      sign_in_user
      let(:question){ create(:question, user: @user) }

      before { patch :select_best_answer, id: answer, question_id: question }

      it 'assign to requiest question' do
        expect(assigns(:question)).to eq question
      end

      it 'assign to requiest answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'change attribute for answer and prev-answer' do
        answer
        prev_answer

        patch :select_best_answer, id: answer, question_id: question
        answer.reload
        prev_answer.reload

        expect(answer).to be_best_answer
        expect(prev_answer).to_not be_best_answer

      end

      it 'redirect to question' do
        expect(response).to redirect_to question
      end
    end

    context 'No Author try select best answer' do
      sign_in_user
      let!(:prev_answer) { create(:answer, best_answer: true, question: question) }
      
      it 'not change attribute for answer and prev-answer' do
        prev_answer
        answer
        patch :select_best_answer, id: answer, question_id: question
        answer.reload
        prev_answer.reload

        expect(answer).to_not be_best_answer
        expect(prev_answer).to be_best_answer
      end
    end
  end

  describe 'POST #vote' do
    context 'Author of answer try vote for answer' do
      sign_in_user
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question, user: @user) }

      it 'rating no change' do
        expect { post :vote, user_id: @user.id, question_id:question.id, id: answer.id, value: 'yes', format: :js }.to_not change(answer.votes, :count)
      end

      it 'render question' do
        post :vote, question_id:question.id, user_id: @user.id, id: answer.id, value: 'yes', format: :js
        expect(response).to render_template :vote
      end
    end
    

    context 'No Author of answer try vote for answer' do 
      sign_in_user
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }

      it 'rating change' do
        expect { post :vote, question_id:question.id, user_id: @user.id, id: answer.id, value: 1, format: :js }.to change(answer.votes, :count)
      end

      it 'render question' do
        post :vote, question_id:question.id, user_id: @user.id, id: answer.id, value: 1, format: :js
        expect(response).to render_template :vote
      end
    end
  end

  context 'DELETE #delete_vote' do 
    context 'No author of answer try reset vote' do
      sign_in_user
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }
      let!(:vote_user) { create(:vote, user: @user, votable: answer) }

      it 'rating reset' do
        vote_user
        expect { post :delete_vote, question_id:question.id, user_id: @user.id, id: answer.id, format: :js }.to change(answer.votes, :count)
      end

      it 'render question' do
        post :delete_vote, question_id:question.id, user_id: @user.id, id: answer.id, format: :js
        expect(response).to render_template :delete_vote
      end
    end
    
    context 'Author of answer try reset vote' do 
      sign_in_user
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question, user: @user) }

      it 'rating no change' do
        expect { post :delete_vote, question_id:question.id, user_id: @user.id, id: answer.id, value: "yes", format: :js }.to_not change(answer.votes, :count)
      end

      it 'render question' do
        post :delete_vote, question_id:question.id, user_id: @user.id, id: answer.id, value: "yes", format: :js
        expect(response).to render_template :delete_vote
      end
    end
  end

end
