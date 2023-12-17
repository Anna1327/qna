# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController, type: :controller do

  let!(:user) { create :user }
  let!(:question) { create :question, author: user }
  let!(:link) { create :link, linkable: question }

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before { login(user) }

      context 'question' do
        context 'user is author of question' do
          it "deletes question's link" do
            expect do 
              delete :destroy, 
                params: { id: question.links.first }, 
                format: :js
            end.to change(question.links, :count).by(-1)
          end

          it 'renders destroy' do
            delete :destroy, 
              params: { id: question.links.first }, 
              format: :js
            expect(response).to render_template :destroy
          end
        end

        context 'user is not author of question' do
          let(:other_user) { create :user }
          let!(:other_question) { create :question, author: other_user }
          let!(:other_link) { create :link, linkable: other_question }

          it "can't delete question's link" do
            expect do
              delete :destroy, 
                params: { id: other_question.links.first }, 
                format: :js
            end.not_to change(other_question.links, :count)
          end

          it 'renders destroy' do
            delete :destroy, 
              params: { id: other_question.links.first }, 
              format: :js
            expect(response).to render_template :destroy
          end
        end
      end
    end

    context 'Unauthenticated user' do
      context 'question' do
        it "can't delete question's link" do
          expect do
            delete :destroy, 
              params: { id: question.links.first },
              format: :js
          end.not_to change(question.links, :count)
        end

        it 'renders destroy' do
          delete :destroy, 
            params: { id: question.links.first }, 
            format: :js
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
