class VotePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def can_vote?
    user.present? && !user.author_of?(record)
  end
end
