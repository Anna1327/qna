# frozen_string_literal: true

class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    render json: current_resource_owner
  end

  def all_users
    render json: User.where.not(id: current_resource_owner.id), each_serializer: ProfileSerializer
  end
end