# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscribersController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question, author: user }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new subscriber in the database' do
          expect do
            post :create,
                 params: { question_id: question },
                 format: :js
          end.to change(question.subscribers, :count).by(1)
        end

        it 'renders create template' do
          post :create,
               params: { question_id: question },
               format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the subscriber' do
          expect do
            post :create,
                 params: { question_id: 0 },
                 format: :js
          end.not_to change(Subscriber, :count)
        end

        it 'renders create template' do
          post :create,
               params: { question_id: 0 },
               format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not save a new subscriber in the database' do
        expect do
          post :create,
               params: { question_id: question },
               format: :js
        end.not_to change(question.subscribers, :count)
      end

      it 'redirects to login page' do
        post :create,
             params: { question_id: question },
             format: :js
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE #destroy', js: true do
    context 'authenticated user' do
      before { login(user) }
      let!(:subscriber) { create :subscriber, question: question, author: user }

      context 'user is author' do
        it 'deletes the subscriber' do
          expect do
            delete :destroy, params: { id: subscriber }, format: :js
          end.to change(question.subscribers, :count).by(-1)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: subscriber }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'user is not author' do
        let!(:subscriber) { create :subscriber, question: question }

        it 'does not deletes others following' do
          expect do 
            delete :destroy, params: { id: subscriber }, format: :js
          end.not_to change(question.subscribers, :count)
        end

        it 'returns 401' do
          delete :destroy, params: { id: subscriber }, format: :js
          expect(response.status).to eq 401
        end
      end
    end

    context 'unauthenticated user' do
      let!(:subscriber) { create :subscriber }

      it 'does not delete subscriber' do
        expect do
          delete :destroy, params: { id: subscriber }, format: :js
        end.not_to change(question.subscribers, :count)
      end

      it 'redirects to login page' do
        delete :destroy, params: { id: subscriber }, format: :js
        expect(response.status).to eq 401
      end
    end
  end
end