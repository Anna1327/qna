require 'rails_helper'

RSpec.describe AnswerPolicy, type: :policy do
  let(:admin) { create :user, admin: true }
  let(:user) { create :user }
  let(:question) { create :question, author: admin }

  subject { described_class }

  permissions ".scope" do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :show? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :create? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :update? do
    it "grants access if user is admin" do
      expect(subject).to permit(admin, create(:answer, question: question, author: admin))
    end

    it "grants access if user is author" do
      expect(subject).to permit(user, create(:answer, question: question, author: user))
    end

    it "denies access if user is not author" do
      expect(subject).not_to permit(user, create(:answer, question: question, author: admin))
    end
  end

  permissions :destroy? do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
