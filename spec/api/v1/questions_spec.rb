# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do

  let(:headers) { { "ACCEPT": 'application/json' } }

  describe "GET /api/v1/questions" do
    let(:api_path) { '/api/v1/questions' }
  
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context "when authorized" do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2, author: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let(:user) { create(:user) }
      let!(:answers) { create_list(:answer, 3, question: question, author: user) }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it "returns 200 status" do
        expect(response).to be_successful
      end

      it "returns list of questions" do
        expect(json['questions'].size).to eq 2
      end

      it "returns all public fields" do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it "contains author object" do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it "contains short title" do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe "answers" do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it "returns list of answers" do
          expect(question_response['answers'].size).to eq 3
        end

        it "returns all public fields" do
          %w[id body correct question_id author_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe "GET /api/v1/questions/:id" do
    let(:user) { create :user }
    let(:access_token) { create :access_token }
    let!(:files) do 
      [
        fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb').to_s, 'text/plain'),
        fixture_file_upload(Rails.root.join('spec', 'spec_helper.rb').to_s, 'text/plain')
      ] 
    end
    let!(:resource) { create :question, files: files, author: user }
    let!(:comments) { create_list(:comment, 3, commentable: resource, author: user) }
    let!(:links) { create_list(:link, 3, linkable: resource) }
    let(:resource_response) { json['question'] }
    let(:api_path) { "/api/v1/questions/#{resource.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context "when authorized" do
      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it "returns 200 status if access token is valid" do
        expect(response).to be_successful
      end

      it "returns all public fields" do
        %w[id title body best_answer_id created_at updated_at].each do |attr|
          expect(resource_response[attr]).to eq resource.send(attr).as_json
        end
      end

      it_behaves_like 'API nestable' do
        let(:skipped_params) { %w[] }
        let(:comments_public_fields) do 
          %w[id body author_id commentable_type 
              commentable_id created_at updated_at]
        end
        let(:links_public_fields) do
          %w[id name url linkable_type linkable_id created_at updated_at]
        end
      end
    end
  end

  describe "GET /api/v1/questions/:id/answers" do
    let(:user) { create :user }
    let(:access_token) { create :access_token }
    let!(:question) { create :question, author: user }
    let!(:answers) { create_list :answer, 3, question: question, author: user }
    let(:answers_response) { json['answers'] }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context "when authorized" do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it "returns 200 status if access token is valid" do
        expect(response).to be_successful
      end

      it "returns list of answers" do
        expect(answers_response.size).to eq 3
      end

      it "returns only question's answers" do
        answers_response.each do |answer|
          expect(answer['question_id']).to eq question.id
        end
      end

      it "returns all public fields" do
        %w[id body author_id question_id created_at updated_at].each do |attr|
          expect(answers_response.first[attr]).to eq question.answers.first.send(attr).as_json
        end
      end
    end
  end

  describe "PATCH /api/v1/questions/:id" do
    let(:user) { create :user }
    let(:access_token) { create :access_token, resource_owner_id: user.id }
    let!(:resource) { create :question, author: user }
    let!(:comments) { create_list(:comment, 3, commentable: resource, author: user) }
    let!(:links) { create_list(:link, 3, linkable: resource) }
    let(:resource_response) { json['question'] }
    let(:api_path) { "/api/v1/questions/#{resource.id}" }

    context "when authorized" do
      context "with valid attributes" do
        before do
          patch api_path, params: { access_token: access_token.token, question: params }, 
            headers: headers
        end

        let(:params) do
          {
            title: "Edited title",
            body: "Edited body",
            links_attributes: [
              "google",
              "https://google.com"
            ]
          }
        end

        it "returns 200 status if access token is valid" do
          expect(response).to be_successful
        end

        it "changes question attributes" do
          resource.reload

          expect(resource.title).to eq "Edited title"
          expect(resource.body).to eq "Edited body"
        end

        it_behaves_like 'API nestable' do
          let(:skipped_params) { %w[files comments] }
          let(:comments_public_fields) do 
            %w[id body author_id commentable_type 
                commentable_id created_at updated_at]
          end
          let(:links_public_fields) do
            %w[id name url linkable_type linkable_id created_at updated_at]
          end
        end
      end

      context "with invalid attributes" do
        before do
          patch api_path, params: { access_token: access_token.token, question: params }, 
            headers: headers
        end

        let(:params) do
          {
            title: "",
            body: "",
            links_attributes: [
              "google",
              "https://google.com"
            ]
          }
        end

        it "question attributes does not changes" do
          resource.reload

          expect(resource.title).to eq resource.title
          expect(resource.body).to eq resource.body
        end
      end
    end

    context "when unauthorized" do
      let(:access_token) { create :access_token }
      let(:params) do
        {
          title: "Edited title",
            body: "Edited body",
            links_attributes: [
              "google",
              "https://google.com"
            ]
        }
      end

      it "returns 401" do
        patch api_path, params: { access_token: access_token.token, question: params }, headers: headers
        expect(response.code.to_i).to eq 401
      end
    end
  end

  describe "POST /api/v1/questions" do
    let(:user) { create :user }
    let(:access_token) { create :access_token, resource_owner_id: user.id }
    let!(:resource) { create :question, author: user }
    let(:api_path) { "/api/v1/questions" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context "when authorized" do
      context "with valid attributes" do
        let(:params) do
          {
            author_id: user.id,
            title: "Test title",
            body: "Test body",
            links_attributes: [
              "google",
              "https://google.com"
            ]
          }
        end

        it "add new question in db" do
          expect do
            post api_path, params: { access_token: access_token.token, question: params }, headers: headers
          end.to change(Question, :count).by(1)
        end

        before do
          post api_path, params: { access_token: access_token.token, question: params }, headers: headers
        end

        it "returns 200 status" do
          expect(response).to be_successful
        end
      end

      context "with invalid attributes" do
        let(:params) do
          {
            title: "",
            body: "",
            links_attributes: [
              "google",
              "https://google.com"
            ]
          }
        end

        it "does not change question count" do
          expect do
            post api_path, params: { access_token: access_token.token, question: params }, headers: headers
          end.not_to change(Question, :count)
        end
      end
    end
  end

  describe "DELETE /api/v1/question/:id" do
    let(:user) { create :user }
    let(:access_token) { create :access_token, resource_owner_id: user.id }
    let!(:resource) { create :question, author: user }
    let(:api_path) { "/api/v1/questions/#{resource.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context "when authorized" do
      it "removes question from db" do
        expect do
          delete api_path, params: { access_token: access_token.token }, headers: headers
        end.to change(Question, :count).by(-1)
      end
    end

    context "when unauthorized" do
      let(:access_token) { create :access_token }

      it 'returns 401' do
        delete api_path, params: { access_token: access_token.token }, headers: headers
        expect(response.code.to_i).to eq 401
      end
    end
  end
end