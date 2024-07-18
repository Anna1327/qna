require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:model) { described_class }
  let(:votable_author) { create :user }
  let(:vote_author) { create :user }
  let(:votable) { create(described_class.to_s.underscore.to_sym, author: votable_author) }
  let(:vote) { create :vote, votable: votable, author: vote_author }

  context 'when liked question' do
    it 'change vote count from 0 to 1' do
      vote.liked
      expect(votable.vote_count).to eq(1)
    end
  end

  context 'when disliked question' do
    it 'change vote count from 0 to -1' do
      vote.disliked
      expect(votable.vote_count).to eq(-1)
    end
  end
end
