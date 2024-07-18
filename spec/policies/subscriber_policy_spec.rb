require 'rails_helper'

RSpec.describe SubscriberPolicy, type: :policy do
  subject { described_class }
  
  let(:user) { create :user }
  let(:author) { create :user }
  let(:question) { create :question, author: author }
  let(:subscriber) { create :subscriber, question: question, author: author }

  permissions :create? do
    it "grant access if user presents" do
      expect(subject).to permit(user, create(:subscriber))
    end

    permissions :destroy? do
      it "grants access if user is author of subscriber" do
        expect(subject).to permit(author, subscriber)
      end

      it "denies access if user is not author of subscriber" do
        expect(subject).not_to permit(user, subscriber)
      end
    end
  end
end