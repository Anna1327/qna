# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API', type: :request do
  let(:user) { create :user }
  let(:access_token) { create :access_token }
  let!(:question) { create :question, author: user }
  let(:resource_response) { response_json['answer'] }
  let(:params) do
    {
      body: body,
      links_attributes: [
        "google",
        "https://google.com"
      ]
    }
  end

  describe "GET /api/v1/answers/:id" do
    let!(:files) do 
      [
        fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb').to_s, 'text/plain'),
        fixture_file_upload(Rails.root.join('spec', 'spec_helper.rb').to_s, 'text/plain')
      ] 
    end
    let!(:resource) { create :answer, question: question, files: files, author: user }
    let!(:comments) { create_list(:comment, 3, commentable: resource, author: user) }
    let!(:links) { create_list(:link, 3, linkable: resource) }
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
    subject { patch api_path, params: { access_token: access_token.token, answer: params }, headers: headers }

    let(:access_token) { create :access_token, resource_owner_id: user.id }
    let!(:resource) { create :answer, author: user }
    let!(:links) { create_list(:link, 2, linkable: resource) }
    let(:api_path) { "/api/v1/answers/#{resource.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context "when authorized" do
      context "with valid attributes" do
        let(:body) { "Edited body" }

        it "returns 200 status" do
          subject
          expect(response).to be_successful
        end

        it "changes answer attributes" do
          subject
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
        let(:body) { "" }

        it "does not changes answer attributes" do
          subject
          resource.reload

          expect(resource.body).to eq resource.body
        end
      end
    end

    context "when unauthorized" do
      let(:body) { "Edited body" }

      it "returns 401" do
        subject
        expect(response.status).to eq 401
      end
    end
  end

  describe "POST /api/v1/answers" do
    subject do
      post api_path, params: { 
        access_token: access_token.token, 
        answer: params.merge!(question_id: question_id) 
      }, headers: headers
    end

    let!(:resource) { create :answer, question: question, author: user }
    let(:api_path) { "/api/v1/answers" }
    let(:question_id) { question.id }
    let(:body) { "Test body" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context "when authorized" do
      context "with valid attributes" do
        it "add new answer in db" do
          expect { subject }.to change(Answer, :count).by(1)
        end

        it "returns 200 status" do
          subject
          expect(response).to be_successful
        end
      end

      context "with invalid attributes" do
        let(:question_id) { 0 }

        it "does not saves answer to db" do
          expect { subject }.not_to change(Answer, :count)
        end
      end
    end
  end

  describe "DELETE /api/v1/answers/:id" do
    subject { delete api_path, params: { access_token: access_token.token }, headers: headers }

    let!(:resource) { create :answer, question: question, author: user }
    let(:api_path) { "/api/v1/answers/#{resource.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context "when authorized" do
      let(:access_token) { create :access_token, resource_owner_id: user.id }

      it "removes answer from db" do
        expect { subject }.to change(Answer, :count).by(-1)
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