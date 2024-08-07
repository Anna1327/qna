# frozen_string_literal: true

require 'rails_helper'

describe 'Users API', type: :request do
  describe 'GET /api/v1/users' do
    let(:api_path) { '/api/v1/users' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'when authorized' do
      let(:users) { create_list :user, 3 }
      let(:me) { users.first }
      let(:other_user) { users.last }
      let(:access_token) { create :access_token, resource_owner_id: me.id }
      let(:user_response) { response_json['users'].last }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status if access token is valid' do
        expect(response).to be_successful
      end

      it 'returns list of users' do
        expect(response_json['users'].size).to eq 2
      end

      it 'does not contain me' do
        response_json['users'].each do |user|
          expect(user['id']).not_to eq me.id
        end
      end

      it 'contains user object' do
        expect(user_response['id']).to eq other_user.id
      end

      it 'returns all public fields' do
        %w[id email role created_at updated_at].each do |attr|
          expect(user_response[attr]).to eq other_user.send(attr).as_json
        end
      end

      it 'does not returns private fields' do
        %w[password encrypted_password].each do |attr|
          expect(user_response).not_to have_key(attr)
        end
      end
    end
  end
end
