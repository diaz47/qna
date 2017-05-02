require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    context 'request with valid query' do
      before { get :index, source: 'Everywhere', query: 'query' }
      it 'send 200 status' do
        expect(response.status).to eq 200
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context 'request with invalid query' do
      before { get :index, source: 'Everywhere', query: '' }
      it 'send 200 status' do
        expect(response.status).to eq 200
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end
    context 'request with invalid source' do
      before { get :index, source: 'SPHINX', query: '' }
      it 'send 200 status' do
        expect(response.status).to eq 200
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end
  end
end
