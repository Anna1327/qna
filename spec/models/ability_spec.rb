require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }


  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question) { create :question, author: user }
    let(:other_question) { create :question, author: other_user }
    let(:answer) { create :answer, question: question, author: user }
    let(:other_answer) { create :answer, question: other_question, author: other_user }
    let(:comment) { create :comment, commentable: question, author: user }
    let(:other_comment) { create :comment, commentable: other_question, author: other_user }

    it { should be_able_to :read, :all }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should_not be_able_to :manage, :all }

    it { should be_able_to :update, question, user: user }
    it { should_not be_able_to :update, other_question, user: user }

    it { should be_able_to :update, answer, user: user }
    it { should_not be_able_to :update, other_answer, user: user }

    it { should be_able_to :update, comment, user: user }
    it { should_not be_able_to :update, other_comment, user: user }
  end
end