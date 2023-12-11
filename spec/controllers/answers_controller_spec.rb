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

  describe "DELETE #destroy" do
    before { login(user) }

    context "when user is answer's author" do
      let!(:answer) { create :answer, question: question, author: user }

      it "deletes the answer" do
        expect do 
          delete :destroy, params: { id: answer }
        end.to change(question.answers, :count).by(-1)
      end

      it "redirects to question" do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context "when user is not answer's author" do
      let(:other_user) { create :user }
      let(:other_question) { create :question, author: other_user }
      let!(:other_answer) { create :answer, question: other_question, author: other_user }

      it "does not delete the answer" do
        expect do
          delete :destroy, params: { id: other_answer }
        end.not_to change(other_question.answers, :count)
      end

      it "redirects to question" do
        delete :destroy, params: { id: other_answer }
        expect(response).to redirect_to question_path(other_question)
      end
    end
  end
end
