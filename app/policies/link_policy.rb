# frozen_string_literal: true

class LinkPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def destroy?
    user&.author_of?(record.linkable)
  end
end
