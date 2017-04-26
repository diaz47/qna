require 'rails_helper'

RSpec.describe SubscribesController, type: :controller do
  context 'POST #create' do
    let(:question) { create(:question) }

    context 'Authorize user' do
      sign_in_user

      it 'create new sub to question' do
        expect{ post :create, id: question.id }.to change(question.subscribes, :count).by(1)
      end

      it 'create new sub to user' do
        expect{ post :create, id: question.id }.to change(@user.subscribes, :count).by(1)
      end
    end
    context 'Unauthorize user' do
      it 'create new sub to question' do
        expect{ post :create, id: question.id, user: nil }.to_not change(question.subscribes, :count)
      end
    end
  end

  context 'DELETE #destroy' do
    let!(:question) { create(:question) }

    context 'Authorize user' do
      sign_in_user

      it 'delete sub from question' do
        expect{ delete :destroy, id: question.id }.to change(question.subscribes, :count).by(-1)
      end

      it 'delete sub from user' do
        expect{ delete :destroy, id: question.id }.to change(@user.subscribes, :count).by(-1)
      end
    end

    context 'Unauthorize user' do
      it 'delete sub from question' do
        expect{ delete :destroy, id: question.id, user: nil }.to_not change(question.subscribes, :count)
      end
    end
  end

end
