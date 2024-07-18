# frozen_string_literal: true

require 'rails_helper'

shared_examples 'voted' do
  let(:user) { create :user }
  let(:votable_author) { create :user }
  let(:votable) { create(described_class.controller_name.singularize.underscore.to_sym, author: votable_author) }

  describe 'POST #liked', js: true do
    context 'Authenticated user' do
      before { login(user) }

      it "can increments #{described_class.controller_name}'s vote" do
        post :liked, params: { id: votable }, format: :json
        expect(votable.vote_count).to eq 1
      end

      it 'liked responds json' do
        post :liked, params: { id: votable }, format: :json
        res = {
          votable_id: votable.id,
          votable_class: votable.class.name.underscore,
          vote_value: 1,
          vote_count: 1
        }.as_json
        expect(JSON.parse(response.body)).to eq res
      end

      it "can't increments #{described_class.controller_name}'s vote twice" do
        post :liked, params: { id: votable }, format: :json
        post :liked, params: { id: votable }, format: :json
        expect(votable.vote_count).to eq 1
      end

      it "can cancel #{described_class.controller_name}'s liked" do
        post :liked, params: { id: votable }, format: :json
        post :disliked, params: { id: votable }, format: :json
        expect(votable.vote_count).to eq 0
      end

      it 'disliked responds json' do
        post :disliked, params: { id: votable }, format: :json
        res = {
          votable_id: votable.id,
          votable_class: votable.class.name.underscore,
          vote_value: -1,
          vote_count: -1
        }.as_json
        expect(JSON.parse(response.body)).to eq res
      end
    end

    context "vote his #{described_class.controller_name}" do
      before { login(votable_author) }

      it "can't increments #{described_class.controller_name}'s vote" do
        post :liked, params: { id: votable }, format: :json
        expect(votable.vote_count).to eq 0
        expect(response.status).to eq 422
      end
    end

    context 'Unauthenticated user' do
      it "can't vote #{described_class.controller_name}" do
        post :liked, params: { id: votable }, format: :json
        expect(votable.vote_count).to eq 0
      end
    end
  end

  describe 'POST #disliked' do
    context 'Authenticated user' do
      before { login(user) }

      it "decrements #{described_class.controller_name}'s vote" do
        post :disliked, params: { id: votable }, format: :json
        expect(votable.vote_count).to eq(-1)
      end

      it "can't decrements #{described_class.controller_name}'s vote twice" do
        post :disliked, params: { id: votable }, format: :json
        post :disliked, params: { id: votable }, format: :json
        expect(votable.vote_count).to eq(-1)
      end

      it "can cancel #{described_class.controller_name}'s liked" do
        post :disliked, params: { id: votable }, format: :json
        post :liked, params: { id: votable }, format: :json
        expect(votable.vote_count).to eq 0
      end
    end

    context "tries to vote his own #{described_class.controller_name}" do
      before { login(votable_author) }

      it "can't decrements #{described_class.controller_name}'s vote" do
        post :disliked, params: { id: votable }, format: :json
        expect(votable.vote_count).to eq 0
        expect(response.status).to eq 422
      end
    end

    context 'Unauthenticated user' do
      it "can't vote #{described_class.controller_name}" do
        post :disliked, params: { id: votable }, format: :json
        expect(votable.vote_count).to eq 0
      end
    end
  end
end
