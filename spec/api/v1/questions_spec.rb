require 'rails_helper'

describe 'Api questions' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let!(:questions) { create_list(:question, 2)}
  let(:question){ questions.first}
  let!(:answer){ create(:answer, question: question)}

  describe 'GET /index' do
    it_behaves_like 'Api authenticable'

    context 'authorized' do
      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'return 2 elements' do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "questions contain #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "answer contain #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:comment) { create(:comment, commentable: question, user: user) }
    let!(:attachment) { create(:attachment, attachable: question) }

    it_behaves_like 'Api authenticable'

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      %w(id title body created_at updated_at).each do |attr|
        it "questions contain #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      context 'comments' do
        it 'included in question' do
          expect(response.body).to have_json_size(1).at_path('comments')
        end

        %w(id body created_at updated_at).each do |attr|
          it "comment contain #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question' do
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
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    let(:ivalid_question){ create(:ivalid_question) }

    it_behaves_like 'Api authenticable'

    context 'authorized' do
      context 'with valid data' do
        it 'render success status' do
          post '/api/v1/questions', question: attributes_for(:question), format: :json, access_token: access_token.token
          expect(response).to be_success
        end

        it 'save question in db' do
          expect{ post '/api/v1/questions', question: attributes_for(:question), format: :json, access_token: access_token.token }.to change(user.questions, :count).by(1)
        end
      end

      context 'width invalid data' do
        it 'resnder error status' do
          post '/api/v1/questions', question: attributes_for(:ivalid_question), format: :json, access_token: access_token.token
          expect(response.status).to eq 422
        end

        it 'not save question in db' do
          expect{ post '/api/v1/questions', question: attributes_for(:ivalid_question), format: :json, access_token: access_token.token }.to_not change(user.questions, :count)
        end
      end
    end

    def do_request(options = {})
      post '/api/v1/questions', params: { format: :json, question: attributes_for(:question) }.merge(options)
    end
  end
end