class AnswerPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def update?
    user.admin? || user.id == record.author.id
  end
end
