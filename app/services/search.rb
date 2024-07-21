# frozen_string_literal: true

class Search
  attr_reader :query, :scope, :page

  def initialize(query, scope, page = 1)
    @query = ThinkingSphinx::Query.escape(query)
    @scope = scope
    @page = page
  end

  def call
    if @scope == Base::Enums::Search::ALL_SCOPE
      ThinkingSphinx.search @query, classes: [Question, Answer, Comment, User], page: @page
    else
      model_klass.search @query, page: @page
    end
  end

  private

  def model_klass
    return if @scope.nil?

    @scope.classify.safe_constantize
  end
end
