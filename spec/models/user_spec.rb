require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscribers).dependent(:destroy) }

  it { should have_many(:rewards) }
  it { should have_many(:votes).class_name('Vote') }
  it { should have_many(:comments).class_name('Comment') }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('FindForOauth') }

    it 'calls FindForOauth' do
      allow(FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
