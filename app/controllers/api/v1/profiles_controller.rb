# frozen_string_literal: true

class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    render json: current_user
  end

  def all_users
    render json: User.where.not(id: current_user.id), each_serializer: ProfileSerializer
  end
end