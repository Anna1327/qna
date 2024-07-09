require 'rails_helper'

RSpec.describe QuestionPolicy, type: :policy do
  let(:user) { create :user }
  let(:admin) { create :user, role: :admin }

  subject { described_class }

  permissions :index?, :show? do
    it 'grants access for all users' do
      expect(subject).to permit(nil, create(:question))
    end
  end

  permissions :new?, :create? do
    it 'grants access if user present' do
      expect(subject).to permit(user, create(:question))
    end
  end

  permissions :update?, :destroy? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, create(:question))
    end

    it 'grants access if user is author' do
      expect(subject).to permit(user, create(:question, author: user))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(user, create(:question, author: admin))
    end
  end
end
