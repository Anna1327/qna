require 'rails_helper'

RSpec.describe AnswerPolicy, type: :policy do
  let(:admin) { create :user, role: :admin }
  let(:user) { create :user }
  let(:question) { create :question, author: user }
  let(:answer) { create :answer, question: question, author: user }

  subject { described_class }

  permissions :create? do
    it 'grants access if user present' do
      expect(subject).to permit(user, answer)
    end
  end

  permissions :update?, :destroy? do
    it "grants access if user is admin" do
      expect(subject).to permit(admin, create(:answer, question: question, author: admin))
    end

    it "grants access if user is author" do
      expect(subject).to permit(user, answer)
    end

    it "denies access if user is not author" do
      expect(subject).not_to permit(user, create(:answer, question: question, author: admin))
    end
  end

  permissions :best_answer? do
    let(:other_user) { create :user }
    let(:other_answer) { create :answer, question: question, author: other_user }

    it "grants access if user is admin" do
      expect(subject).to permit(admin, answer)
    end

    it "grants access if user is question's author" do
      expect(subject).to permit(user, other_answer)
    end

    it "denies access if user is not question's author" do
      expect(subject).to_not permit(other_user, answer)
    end
  end
end
