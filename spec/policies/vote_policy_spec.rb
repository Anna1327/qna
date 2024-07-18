require 'rails_helper'

RSpec.describe VotePolicy, type: :policy do
  let(:user) { create :user }
  let(:other_user) { create :user }
  let(:votable) { create :question, author: user }
  let(:other_votable) { create :question, author: other_user }

  subject { described_class }

  permissions :can_vote? do
    it 'grants access if user is not author of votable' do
      expect(subject).to permit(user, other_votable)
    end

    it 'denies access if user is not present' do
      expect(subject).not_to permit(nil, votable)
    end

    it 'denies access if user is author of votable' do
      expect(subject).not_to permit(user, votable)
    end
  end
end
