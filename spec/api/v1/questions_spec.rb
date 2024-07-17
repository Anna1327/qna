# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let!(:user) { create(:user) }
  let!(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let(:params) do
    {
      title: title,
      body: body,
      links_attributes: [
        "google",
        "https://google.com"
      ]
    }
  end

  describe "GET /api/v1/questions" do
    subject { get api_path, params: { access_token: access_token.token }, headers: headers }

    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context "when authorized" do
      let!(:questions) { create_list(:question, 2, author: user) }
      let(:question) { questions.first }
      let(:question_response) { response_json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question, author: user) }

      before do
        subject
      end

      it "returns 200 status" do
        expect(response).to be_successful
      end

      it "returns list of questions" do
        expect(response_json['questions'].size).to eq 2
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

      context "with answers" do
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
    let!(:files) do 
      [
        fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb').to_s, 'text/plain'),
        fixture_file_upload(Rails.root.join('spec', 'spec_helper.rb').to_s, 'text/plain')
      ] 
    end
    let!(:resource) { create :question, files: files, author: user }
    let!(:comments) { create_list(:comment, 3, commentable: resource, author: user) }
    let!(:links) { create_list(:link, 3, linkable: resource) }
    let(:resource_response) { response_json['question'] }
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

      it_behaves_like 'API nestable links' do
        let(:links_public_fields) do
          %w[id name url linkable_type linkable_id created_at updated_at]
        end
      end

      it_behaves_like 'API nestable comments' do
        let(:comments_public_fields) do 
          %w[id body author_id commentable_type 
              commentable_id created_at updated_at]
        end
      end

      it_behaves_like 'API nestable files'
      it_behaves_like 'API nestable author'
    end
  end

  describe "GET /api/v1/questions/:id/answers" do
    let!(:question) { create :question, author: user }
    let!(:answers) { create_list :answer, 3, question: question, author: user }
    let(:answers_response) { response_json['answers'] }
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
    subject do 
      patch api_path, params: { 
        access_token: access_token.token, 
        question: params 
      }, headers: headers
    end

    let!(:resource) { create :question, author: user }
    let!(:comments) { create_list(:comment, 3, commentable: resource, author: user) }
    let!(:links) { create_list(:link, 3, linkable: resource) }
    let(:resource_response) { response_json['question'] }
    let(:api_path) { "/api/v1/questions/#{resource.id}" }
    let(:title) { "Edited title" }
    let(:body) { "Edited body" }

    context "when authorized" do
      before do
        subject
      end

      context "with valid attributes" do
        it "returns 200 status if access token is valid" do
          expect(response).to be_successful
        end

        it "changes question attributes" do
          resource.reload
          expect(resource).to have_attributes(title: "Edited title", body: "Edited body")
        end

        it_behaves_like 'API nestable links' do
          let(:links_public_fields) do
            %w[id name url linkable_type linkable_id created_at updated_at]
          end
        end
        it_behaves_like 'API nestable author'
      end

      context "with invalid attributes" do
        let(:title) { "" }
        let(:body) { "" }

        it "question attributes does not changes" do
          resource.reload
          expect(resource).to have_attributes(title: resource.title, body: resource.body)
        end
      end
    end

    context "when unauthorized" do
      it "returns 401" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "POST /api/v1/questions" do
    subject { post api_path, params: { access_token: access_token.token, question: params }, headers: headers }

    let!(:resource) { create :question, author: user }
    let(:api_path) { "/api/v1/questions" }
    let(:title) { "Edited title" }
    let(:body) { "Edited body" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context "when authorized" do
      context "with valid attributes" do
        it "add new question in db" do
          expect do
            post api_path, params: { 
              access_token: access_token.token, 
              question: params.merge!(author_id: user.id) 
            }, headers: headers
          end.to change(Question, :count).by(1)
        end

        it "returns 200 status" do
          subject
          expect(response).to be_successful
        end
      end

      context "with invalid attributes" do
        let(:title) { "" }
        let(:body) { "" }

        it "does not change question count" do
          expect do
            subject
          end.not_to change(Question, :count)
        end
      end
    end
  end

  describe "DELETE /api/v1/question/:id" do
    subject { delete api_path, params: { access_token: access_token.token }, headers: headers }

    let!(:resource) { create :question, author: user }
    let(:api_path) { "/api/v1/questions/#{resource.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context "when authorized" do
      it "removes question from db" do
        expect do
          subject
        end.to change(Question, :count).by(-1)
      end
    end

    context "when unauthorized" do
      it "returns 401" do
        subject
        expect(response.status).to eq 401
      end
    end
  end
end