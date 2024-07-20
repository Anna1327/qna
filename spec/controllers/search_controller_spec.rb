# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do
    let(:service) { double('Search') }

    context 'with query' do
      it 'assigns scope' do
        get :search, params: { query: 'test_query', scope: 'all' }
        expect(assigns(:scope)).to eq 'all'
      end

      it 'assigns query' do
        get :search, params: { query: 'test_query', scope: 'all' }
        expect(assigns(:query)).to eq 'test_query'
      end

      it 'assigns result' do
        expect(assigns(:result)).to_not be
      end

      it 'returns success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders search view' do
        get :search, params: { query: 'test_query', scope: 'all' }
        expect(response).to render_template 'search/_result'
      end

      it 'calls Services::Search' do
        allow(Search).to receive(:new).and_return(service)
        expect(service).to receive(:call)
        get :search, params: { query: 'test_query', scope: 'all' }
      end
    end

    context 'without query' do
      before { get :search, params: { query: '', scope: 'all' } }

      it 'not assigns result' do
        expect(assigns(:result)).to_not be
      end

      it 'returns success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders search view' do
        expect(response).to render_template 'search/_result'
      end

      it 'not calls Services::Search' do
        allow(Search).to receive(:new).and_return(service)
        expect(service).to_not receive(:call)
        get :search, params: { query: '', scope: 'all' }
      end
    end
  end
end
