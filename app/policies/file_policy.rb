class FilePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
  
  def destroy?
    user&.author_of?(record)
  end
end
