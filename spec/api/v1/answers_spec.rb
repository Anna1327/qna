# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API', type: :request do

  let(:headers) { { "ACCEPT": 'application/json' } }

  describe "GET /api/v1/answers/:id" do
    let(:user) { create :user }
    let(:access_token) { create :access_token }
    let!(:question) { create :question, author: user }
    let!(:files) do 
      [
        fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb').to_s, 'text/plain'),
        fixture_file_upload(Rails.root.join('spec', 'spec_helper.rb').to_s, 'text/plain')
      ] 
    end
    let!(:resource) { create :answer, question: question, files: files, author: user }
    let!(:comments) { create_list(:comment, 3, commentable: resource, author: user) }
    let!(:links) { create_list(:link, 3, linkable: resource) }
    let(:resource_response) { json['answer'] }
    let(:api_path) { "/api/v1/answers/#{resource.id}" }
  
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
        %w[id body question_id created_at updated_at].each do |attr|
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

  describe "PATCH /api/v1/answers/:id" do
    let(:user) { create :user, role: "admin" }
    let(:access_token) { create :access_token, resource_owner_id: user.id }
    let!(:resource) { create :answer, author: user }
    let!(:links) { create_list(:link, 2, linkable: resource) }
    let(:resource_response) { json['answer'] }
    let(:api_path) { "/api/v1/answers/#{resource.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context "authorized" do
      context "with valid attributes" do
        let(:params) do
          {
            body: "Edited body",
            links_attributes: [
              "google",
              "https://google.com"
            ]
          }
        end

        before do
          patch api_path, params: { access_token: access_token.token, answer: params }, headers: headers
        end

        it "returns 200 status" do
          expect(response).to be_successful
        end

        it "changes answer attributes" do
          patch api_path, params: { access_token: access_token.token, answer: params }, headers: headers
          resource.reload

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
        let(:params) do
          {
            body: "",
            links_attributes: [
              "google",
              "https://google.com"
            ]
          }
        end

        it "does not changes answer attributes" do
          patch api_path, params: { access_token: access_token.token, answer: params }, headers: headers
          resource.reload

          expect(resource.body).to eq resource.body
        end
      end
    end

    context "when unauthorized" do
      let(:access_token) { create :access_token }
      let(:params) do
        {
          body: "Edited body",
          links_attributes: [
            "google",
            "https://google.com"
          ]
        }
      end

      it "returns 401" do
        patch api_path, params: { access_token: access_token.token, answer: params }, headers: headers
        expect(response.code.to_i).to eq 401
      end
    end
  end

  describe "POST /api/v1/answers" do
    let(:user) { create :user }
    let(:access_token) { create :access_token, resource_owner_id: user.id }
    let!(:question) { create :question, author: user }
    let!(:resource) { create :answer, question: question, author: user }
    let(:api_path) { "/api/v1/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context "when authorized" do
      context "with valid attributes" do
        let(:params) do
          {
            question_id: question.id,
            body: "Test body",
            links_attributes: [
              "google",
              "https://google.com"
            ]
          }
        end

        it "add new answer in db" do
          expect do
            post api_path, params: { access_token: access_token.token, answer: params }, headers: headers
          end.to change(Answer, :count).by(1)
        end

        before do
          post api_path, params: { access_token: access_token.token, answer: params }, headers: headers
        end

        it "returns 200 status" do
          expect(response).to be_successful
        end
      end

      context "with invalid attributes" do
        let(:params) do
          {
            question_id: 0,
            body: "",
            links_attributes: [
              "google",
              "https://google.com"
            ]
          }
        end

        it "does not saves answer to db" do
          expect do
            post api_path, params: { access_token: access_token.token, answer: params }, headers: headers
          end.not_to change(Answer, :count)
        end
      end
    end
  end

  describe "DELETE /api/v1/answer/:id" do
    let(:user) { create :user }
    let(:access_token) { create :access_token, resource_owner_id: user.id }
    let!(:question) { create :question, author: user }
    let!(:resource) { create :answer, question: question, author: user }
    let(:api_path) { "/api/v1/answers/#{resource.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context "when authorized" do
      it "removes answer from db" do
        expect do
          delete api_path, params: { access_token: access_token.token }, headers: headers
        end.to change(Answer, :count).by(-1)
      end
    end

    context "when unauthorized" do
      let(:access_token) { create :access_token }

      it "returns 401" do
        delete api_path, params: { access_token: access_token.token }, headers: headers
        expect(response.code.to_i).to eq 401
      end
    end
  end
end