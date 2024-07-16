# frozen_string_literal: true

class Api::V1::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :doorkeeper_authorize!
  before_action :current_user, only: %i[create update destroy]

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  alias current_user current_resource_owner
  private :current_resource_owner
end