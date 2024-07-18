require 'rails_helper'

RSpec.describe FindForOauth do
  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

  describe '#call' do
    subject { described_class.new(auth).call }

    context 'user already has authorization' do
      let(:authorization) { create :authorization, user: user, provider: 'facebook', uid: '123456' }

      it 'returns the user' do
        expect(subject).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user has already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

        it 'does not create new user' do
          expect { subject }.not_to change(User, :count)
        end

        it 'creates authorization for user' do
          expect { subject }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = subject.authorizations.first
          expect(authorization.provider).to eq(auth.provider)
          expect(authorization.uid).to eq(auth.uid)
        end

        it 'returns the user' do
          expect(subject).to eq user
        end
      end
    end

    context 'user does not exists' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

      it 'creates new user' do
        expect { subject }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(subject).to be_a(User)
      end

      it 'fill user email' do
        expect(user.email).to eq(auth.info['email'])
      end

      it 'creates authorization for user' do
        expect { subject }.to change(user.authorizations, :count).by(1)
      end

      it 'creates authorization with provider and uid' do
        authorization = subject.authorizations.first
        expect(authorization).to have_attributes(provider: 'facebook', uid: '123456')
      end
    end
  end
end
