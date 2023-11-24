# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }

  describe "POST #create" do
    context "with valid attributes" do
      it "saves a new answer in the database" do
        expect do
          post :create, params: { 
            question_id: question, 
            answer: attributes_for(:answer, question: question) 
          }
        end.to change(Answer, :count).by(1)
      end

      it "redirects to question view" do
        post :create, params: { 
          question_id: question, 
          answer: attributes_for(:answer, question: question)
        }

        expect(response).to redirect_to assigns(:question)
      end
    end

    context "with invalid attributes" do
      it "do not save a new answer" do
        expect do
          post :create, params: { 
            question_id: question, 
            answer: attributes_for(:answer, :invalid, question: question) 
          }
        end.not_to change(Answer, :count)
      end

      it "re-renders new view" do
        post :create, params: { 
          question_id: question, 
          answer: attributes_for(:answer, :invalid, question: question) 
        }
        expect(response).to render_template :new
      end
    end
  end
end
