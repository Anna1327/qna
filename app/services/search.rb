# frozen_string_literal: true
class Search
  attr_reader :query, :scope, :page

  ALL = 'all'

  def initialize(query, scope, page = 1)
    @query = ThinkingSphinx::Query.escape(query)
    @scope = scope
    @page = page
  end

  def call
    if @scope == ALL
      ThinkingSphinx.search @query, classes: [Question, Answer, Comment, User], page: @page
    else
      model_klass.search @query, page: @page
    end
  end

  private

  def model_klass
    @scope.classify.constantize
  end
end