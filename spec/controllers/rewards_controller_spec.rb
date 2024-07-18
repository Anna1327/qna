# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create :user }
  let(:reward) { create :reward, user: user }

  describe 'GET #index' do
    context 'Authenticated user' do
      before do
        login(user)
        get :index
      end

      it 'populates an array of all rewards' do
        expect(assigns(:rewards)).to match_array(user.rewards)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context 'Unauthenticated user' do
      before { get :index }

      it 'redirects to login view' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
