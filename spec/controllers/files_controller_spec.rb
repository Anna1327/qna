# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let!(:user) { create :user }
  let!(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before { login(user) }

      context 'user is author of question' do
        let!(:question) { create :question, author: user, files: [file] }

        it "deletes question's file" do
          expect do
            delete :destroy,
                   params: { id: question.files.first },
                   format: :js
          end.to change(question.files, :count).by(-1)
        end

        it 'renders to show question' do
          delete :destroy,
                 params: { id: question.files.first },
                 format: :js
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'user is not author of question' do
        let(:other_user) { create :user }
        let!(:other_question) { create :question, author: other_user, files: [file] }

        it "can't delete question's file" do
          other_question.files.attach(file)

          expect do
            delete :destroy,
                   params: { id: other_question.files.first },
                   format: :js
          end.not_to change(other_question.files, :count)
        end

        it 'renders to show question' do
          delete :destroy,
                 params: { id: other_question.files.first },
                 format: :js
          expect(response).to redirect_to assigns(:question)
        end
      end
    end

    context 'Unauthenticated user' do
      let!(:question) { create :question, author: user, files: [file] }

      it "can't delete question's file" do
        expect do
          delete :destroy,
                 params: { id: question.files.first },
                 format: :js
        end.not_to change(question.files, :count)
      end

      it 'renders destroy' do
        delete :destroy,
               params: { id: question.files.first },
               format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
