require 'rails_helper'

RSpec.describe AuthorizationsController, type: :controller do
  describe 'GET #new' do
    it 'renders new view' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'when new user' do
      it 'creates new user' do
        expect do
          post :create, params: { uid: 123, provider: 'vkontakte', email: 'user@mail.com' }
        end.to change(User, :count).by(1)
      end

      it 'creates authorization' do
        expect do
          post :create, params: { uid: 123, provider: 'vkontakte', email: 'user@mail.com' }
        end.to change(Authorization, :count).by(1)
      end

      it 'redirects to root path' do
        post :create, params: { uid: 123, provider: 'vkontakte', email: 'user@mail.com' }
        expect(response).to redirect_to root_path
      end
    end

    context 'when user exists' do
      let!(:user) { create :user }

      it 'does not creates new user' do
        expect do
          post :create, params: { uid: 123, provider: 'vkontakte', email: user.email }
        end.not_to change(User, :count)
      end

      it 'redirects to root path' do
        post :create, params: { uid: 123, provider: 'vkontakte', email: user.email }
        expect(response).to redirect_to root_path
      end

      context 'when new authorization' do
        it 'creates authorization' do
          expect do
            post :create, params: { uid: 123, provider: 'vkontakte', email: user.email }
          end.to change(Authorization, :count).by(1)
        end
      end

      describe 'GET #email_confirmation' do
        let!(:user) { create :user }
        let!(:authorization) { create :authorization, user: user, confirmation_token: 'qwerty' }

        before do
          get :email_confirmation, params: {
            authorization_id: authorization,
            confirmation_token: authorization.confirmation_token }
        end

        it 'accepts token' do
          authorization.reload
          expect(authorization.confirm).to eq(true)
        end

        it 'login user' do
          expect(subject.current_user).to eq user
        end

        it 'redirects to root path' do
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
