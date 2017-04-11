require 'rails_helper'

describe 'Api answers' do
  describe 'GET /index' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let!(:question){ create(:question)}
    let!(:answer){ create(:answer, question: question)}

    context 'unauthorized' do
      it 'return status 401 if call without access_token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end
      it 'return status 401 if call with wrong access_token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '123342342'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'return success status' do
        expect(response).to be_success
      end

      it 'return 1 element' do
        expect(response.body).to have_json_size(1)
      end

      %w(id body created_at updated_at best_answer rating).each do |attr|
        it "answers contain #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:question){ create(:question) }
      let!(:answer){ create(:answer, question: question)}
      let!(:comment) { create(:comment, commentable: answer, user: user) }
      let!(:attachment) { create(:attachment, attachable: answer) }

      context 'unauthorized' do
        it 'return status 401 if call without access_token' do
          get "/api/v1/answers/#{answer.id}", format: :json
          expect(response.status).to eq 401
        end

        it 'return status 401 if call with wrong access_token' do
          get "/api/v1/answers/#{answer.id}", format: :json, access_token: '123342342'
          expect(response.status).to eq 401
        end
      end

      context 'authorized' do
        before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

        %w(id body created_at updated_at).each do |attr|
          it "answer contain #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr)
          end
        end

        context 'comments' do
          it 'included in answer' do
            expect(response.body).to have_json_size(1).at_path('comments')
          end

          %w(id body created_at updated_at).each do |attr|
            it "comment contain #{attr}" do
              expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
            end
          end
        end

        context 'attachments' do
          it 'included in answer' do
            expect(response.body).to have_json_size(1).at_path('attachments')
          end

          %w(id file_url).each do |attr|
            it "attachments has: #{attr}" do
              expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
            end
          end
        end
      end
    end

  describe 'POST /create' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let!(:question){ create(:question) }
    let!(:answer){ create(:answer, question: question)}

    context 'unauthorized' do
      it 'return status 401 if call without access_token' do
        post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json
        expect(response.status).to eq 401
      end

      it 'return status 401 if call with wrong access_token' do
        post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: '123342342'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      context 'with valid data' do
        it 'render success status' do
          post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: access_token.token
          expect(response).to be_success
        end

        it 'save question in db' do
          expect{ post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: access_token.token }.to change(question.answers, :count).by(1)
        end
      end

      context 'width invalid data' do
        it 'resnder error status' do
          post "/api/v1/questions/#{question.id}/answers", answer: { body: nil }, format: :json, access_token: access_token.token
          expect(response.status).to eq 422
        end

        it 'not save question in db' do
          expect{ post "/api/v1/questions/#{question.id}/answers", answer: { body: nil }, format: :json, access_token: access_token.token }.to_not change(user.questions, :count)
        end
      end
    end
  end
  
end