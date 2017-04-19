require 'rails_helper'

describe 'Api answers' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let!(:question){ create(:question) }
  let!(:answer){ create(:answer, question: question) }

  describe 'GET /index' do
    it_behaves_like 'Api authenticable'

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'return 1 element' do
        expect(response.body).to have_json_size(1)
      end

      %w(id body created_at updated_at best_answer rating).each do |attr|
        it "answers contain #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:comment) { create(:comment, commentable: answer, user: user) }
    let!(:attachment) { create(:attachment, attachable: answer) }

    it_behaves_like 'Api authenticable'

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

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'Api authenticable'
    
    context 'authorized' do
      context 'with valid data' do
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

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json }.merge(options)
    end
  end
end