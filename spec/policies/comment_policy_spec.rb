# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentPolicy, type: :policy do
  let(:user) { create :user }
  let(:question) { create :question, author: user }
  let(:comment) { create :comment, commentable: question, author: user }

  subject { described_class }

  permissions :create? do
    it 'grants access if user presents' do
      expect(subject).to permit(user, comment)
    end

    it 'denies access if user is not present' do
      expect(subject).not_to permit(nil, comment)
    end
  end

  permissions :destroy? do
    it 'grants access if user is author of comment' do
      expect(subject).to permit(user, comment)
    end

    it 'denies access if user is not author of comment' do
      expect(subject).not_to permit(User.new, comment)
    end
  end
end
