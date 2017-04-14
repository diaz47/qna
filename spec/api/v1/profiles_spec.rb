require 'rails_helper'

describe 'Profile Api' do
  describe 'GET /me' do
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    it_behaves_like 'Api authenticable'

    context 'authorized' do
      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      %w(email id created_at updated_at admin).each do |attr|
        it "contain #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end

    end

    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /index' do
    let!(:users) { create_list(:user, 5) }
    let(:access_token) { create(:access_token, resource_owner_id: users[4].id) }

    it_behaves_like 'Api authenticable'

    context 'authorized' do
      let!(:users) { create_list(:user, 5) }
      let(:access_token) { create(:access_token, resource_owner_id: users[4].id) }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it 'return list users' do
        expect(response.body).to have_json_size(4)
      end

      %w(email id created_at updated_at admin).each do |attr|
        it "contain #{attr}" do
          expect(response.body).to be_json_eql(users[0].send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "not contain #{attr}" do
          expect(response.body).to_not have_json_path("0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles', params: { format: :json }.merge(options)
    end
  end
end