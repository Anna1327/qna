# frozen_string_literal: true

class SearchController < ApplicationController
  before_action :set_params

  def search
    @result = Search.new(@query, @scope, @page).call unless @query.blank?
    render partial: 'search/result'
  end

  private

  def set_params
    @scope = params[:scope] || Base::Enums::Search::ALL_SCOPE
    @query = params[:query].to_s
    @page = params[:page]
  end
end
