class QuestionPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def update?
    user&.admin? || user&.author_of?(record)
  end

  def destroy?
    user&.admin? || user&.author_of?(record)
  end
end
