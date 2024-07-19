# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::BaseController
  def index
    render json: User.where.not(id: current_user.id), each_serializer: ProfileSerializer
  end
end
