require 'rails_helper'

describe 'Profile Api' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'return status 401 if call without access_token' do
        get '/api/v1/profiles/me', format: :json
        expect(response.status).to eq 401
      end
      it 'return status 401 if call with wrong access_token' do
        get '/api/v1/profiles/me', format: :json, access_token: '123342342'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it 'return status 200' do
        expect(response).to be_success
      end

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
  end

  describe 'GET /users' do
    context 'unauthorized' do
      it 'return status 401 if call without access_token' do
        get '/api/v1/profiles/users', format: :json
        expect(response.status).to eq 401
      end
      it 'return status 401 if call with wrong access_token' do
        get '/api/v1/profiles/users', format: :json, access_token: '123342342'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:users) { create_list(:user, 5) }
      let(:access_token) { create(:access_token, resource_owner_id: users[4].id) }

      before { get '/api/v1/profiles/users', format: :json, access_token: access_token.token }

      it 'return status 200' do
        expect(response).to be_success
      end

      it 'return list users' do
        expect(response.body).to have_json_size(4)
      end

      %w(email id created_at updated_at admin).each do |attr|
        it "contain #{attr}" do
          expect(response.body).to be_json_eql(users[0].send(attr.to_sym).to_json).at_path("0/#{attr}")
          expect(response.body).to be_json_eql(users[1].send(attr.to_sym).to_json).at_path("1/#{attr}")
          expect(response.body).to be_json_eql(users[2].send(attr.to_sym).to_json).at_path("2/#{attr}")
          expect(response.body).to be_json_eql(users[3].send(attr.to_sym).to_json).at_path("3/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "not contain #{attr}" do
          expect(response.body).to_not have_json_path("0/#{attr}")
          expect(response.body).to_not have_json_path("1/#{attr}")
          expect(response.body).to_not have_json_path("2/#{attr}")
          expect(response.body).to_not have_json_path("3/#{attr}")
        end
      end

    end
  end
end