# frozen_string_literal: true

shared_examples_for 'API nestable author' do
  describe 'when check author' do
    it 'contains author object' do
      expect(resource_response['author']['id']).to eq resource.author_id
    end
  end
end
