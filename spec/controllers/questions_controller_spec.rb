# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create :question, author: user }

  describe "GET #index" do
    let(:questions) { create_list :question, 3, author: user }

    before { get :index }

    it "populates an array of all questions" do
      expect(assigns(:questions)).to match_array(questions)
    end

    it "renders index view" do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    before { get :show, params: { id: question.id } }

    it "assigns the requested question to @question" do
      expect(assigns(:question)).to eq question
    end

    it "assigns the answer for question" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it "renders show view" do
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    before { login(user) }

    before { get :new }

    it "renders new view" do
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    before { login(user) }

    before { get :edit, params: { id: question.id } }

    it "renders edit view" do
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    before { login(user) }

    context "with valid attributes" do
      it "saves a new question in the database" do
        expect do
          post :create, params: { question: attributes_for(:question) }
        end.to change(Question, :count).by(1)
      end

      it "redirects to show view" do
        post :create, params: { question: attributes_for(:question) }

        expect(response).to redirect_to assigns(:question)
      end
    end

    context "with invalid attributes" do
      it "do not save the question" do
        expect do
          post :create, params: { question: attributes_for(:question, :invalid) }
        end.not_to change(Question, :count)
      end

      it "re-renders new view" do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do
    before { login(user) }

    context "with valid attributes" do
      it "assigns the requested question to @question" do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq(question)
      end

      it "change question attributes" do
        patch :update, params: { id: question, question: { title: "new title", body: "new body" } }
        question.reload
        expect(question.title).to eq("new title")
        expect(question.body).to eq("new body")
      end

      it "redirects to updated question" do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context "with invalid attributes" do
      before do 
        patch :update, params: { 
          id: question, 
          question: attributes_for(:question, :invalid) 
        }
      end

      it "do not change the question" do
        question.reload
        expect(question.title).to eq("Title of the question")
        expect(question.body).to eq("Body of the question")
      end

      it "re-renders edit view" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    before { login(user) }

    let!(:question) { create :question, author: user }

    it "deletes the question" do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it "redirects to index" do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end
end
