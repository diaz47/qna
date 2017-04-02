require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:commentable) { create(:question) }
  let(:comment) { { body: "comment", commentable_type: commentable.class.name, commentable_id: commentable.id } }
  describe 'POST #create' do
    sign_in_user
    context 'with valid data' do
      it 'save comment in db' do
        expect{ post :create, comment: comment, format: :js}.to change(commentable.comments, :count).by(1)
      end

      it 'assign commentable' do
        post :create, comment: comment, format: :js
        expect(assigns(:commentable)).to eq(commentable)
      end

      it 'assigns comment' do
        post :create, comment: comment, format: :js
        expect(assigns(:comment).body).to eq(comment[:body])
        expect(assigns(:comment).commentable_type).to eq(comment[:commentable_type])
        expect(assigns(:comment).commentable_id).to eq(comment[:commentable_id])
      end

      it 'return 200 status' do
        post :create, comment: comment, format: :js
        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid comment' do
      let(:ivalid_comment) { { body: "", commentable_type: commentable.class.name, commentable_id: commentable.id } }

      it 'do not save in db' do
        expect{ post :create, comment: ivalid_comment, format: :js}.to_not change(commentable.comments, :count)
      end
      it 'return 422 status code' do
        post :create, comment: ivalid_comment, format: :js
        expect(response).to have_http_status(422)
      end
    end
  end
end
