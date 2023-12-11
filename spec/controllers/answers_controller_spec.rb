# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question, author: user }

  describe "POST #create" do
    before { login(user) }

    context "with valid attributes" do
      it "when saves a new answer in the database" do
        expect do
          post :create, params: { 
            question_id: question, 
            answer: attributes_for(:answer, question: question) 
          }, format: :js
        end.to change(Answer, :count).by(1)
      end

      it "renders create template" do
        post :create, params: { 
          question_id: question, 
          answer: attributes_for(:answer, question: question)
        }, format: :js

        expect(response).to render_template :create
      end
    end

    context "with invalid attributes" do
      it "when do not save a new answer" do
        expect do
          post :create, params: { 
            question_id: question, 
            answer: attributes_for(:answer, :invalid, question: question) 
          }, format: :js
        end.not_to change(Answer, :count)
      end

      it "renders create template" do
        post :create, params: { 
          question_id: question, 
          answer: attributes_for(:answer, :invalid, question: question) 
        }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    let!(:answer) { create :answer, question: question, author: user }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update,
              params: { id: answer, answer: { body: 'New body' } },
              format: :js
        answer.reload
        expect(answer.body).to eq'New body'
      end

      it 'renders update template' do
        patch :update,
              params: { id: answer, answer: { body: 'New body' } },
              format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update,
                params: { id: answer, answer: attributes_for(:answer, :invalid) },
                format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update template' do
        patch :update,
              params: { id: answer, answer: { body: 'New body' } },
              format: :js
        expect(response).to render_template :update
      end
    end

    context "other's answer" do
      let(:other_user) { create :user }
      let(:other_question) { create :question, author: other_user }
      let!(:other_answer) { create :answer, question: other_question, author: other_user }

      it 'does not change answer attributes' do
        expect do
          patch :update,
                params: { id: other_answer, answer: { body: 'Updated body' } },
                format: :js
        end.to_not change(other_answer, :body)
      end
      it 'redirects to question' do
        patch :update,
              params: { id: other_answer, answer: { body: 'Updated body' } },
              format: :js

        expect(response.status).to render_template :update
      end
    end
  end

  describe "DELETE #destroy" do
    before { login(user) }

    context "when user is answer's author" do
      let!(:answer) { create :answer, question: question, author: user }

      it "deletes the answer" do
        expect do 
          delete :destroy, params: { id: answer }, format: :js
        end.to change(question.answers, :count).by(-1)
      end

      it "renders destroy template" do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "when user is not answer's author" do
      let(:other_user) { create :user }
      let(:other_question) { create :question, author: other_user }
      let!(:other_answer) { create :answer, question: other_question, author: other_user }

      it "does not delete the answer" do
        expect do
          delete :destroy, params: { id: other_answer }, format: :js
        end.not_to change(other_question.answers, :count)
      end

      it "renders destroy template" do
        delete :destroy, params: { id: other_answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
