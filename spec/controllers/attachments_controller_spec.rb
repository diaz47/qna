require 'rails_helper'
RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do

    context 'User try delete qustion file`s' do
      context 'Author of question try delete question file`s' do
        sign_in_user
        let(:question){ create(:question, user: @user)}
        let(:question_attachment) { create(:attachment, attachable: question) }

        it 'delete attachment from the db' do
          question_attachment
          expect { delete :destroy, id: question_attachment, format: :js }.to change(question.attachments, :count).by(-1)
        end

        it 'render template' do
          delete :destroy, id: question_attachment, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'No Author of question try delete question file`s' do
        sign_in_user
        let(:question){ create(:question)}
        let(:question_attachment) { create(:attachment, attachable: question) }

        it 'delete attachment from the db' do
          question_attachment
          expect { delete :destroy, id: question_attachment, format: :js }.to_not change(question.attachments, :count)
        end
        it 'render template' do
          delete :destroy, id: question_attachment, format: :js
          expect(response).to render_template :destroy
        end

      end

      context 'No signed user try delete question file`s' do
        let(:question){ create(:question)}
        let(:question_attachment) { create(:attachment, attachable: question) }

        it 'delete attachment from the db' do
          question_attachment
          expect { delete :destroy, id: question_attachment, format: :js }.to_not change(question.attachments, :count)
        end
      end
    end

    context 'User try delete answer file`s' do 
      context 'Author of answer try delete question file`s' do
        sign_in_user
        let(:question){ create(:question, user: @user)}
        let(:answer){ create(:answer, user: @user, question: question)}
        let(:answer_attachment){ create(:attachment, attachable: answer)}

        it 'delete attachment from the db' do
          answer_attachment
          expect { delete :destroy, id: answer_attachment, format: :js }.to change(answer.attachments, :count).by(-1)
        end

        it 'render template' do
          delete :destroy, id: answer_attachment, format: :js
          expect(response).to render_template :destroy
        end
      end
      context 'No Author of answer try delete question file`s' do
        sign_in_user
        let(:question){ create(:question)}
        let(:answer){ create(:answer, question: question)}
        let(:answer_attachment){ create(:attachment, attachable: answer)}

        it 'delete attachment from the db' do
          answer_attachment
          expect { delete :destroy, id: answer_attachment, format: :js }.to_not change(answer.attachments, :count)
        end

        it 'render template' do
          delete :destroy, id: answer_attachment, format: :js
          expect(response).to render_template :destroy
        end
      end
      context 'No signed user try delete question file`s' do
        let(:question){ create(:question)}
        let(:answer){ create(:answer, question: question)}
        let(:answer_attachment){ create(:attachment, attachable: answer)}

        it 'delete attachment from the db' do
          answer_attachment
          expect { delete :destroy, id: answer_attachment, format: :js }.to_not change(answer.attachments, :count)
        end
      end
    end
  end
end