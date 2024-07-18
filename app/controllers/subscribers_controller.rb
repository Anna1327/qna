# frozen_string_literal: true

class SubscribersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :find_subscriber, only: %i[destroy]

  def create
    authorize Subscriber
    @subscriber = current_user.subscribers.build(subscriber_params)
    @subscriber.save
  end

  def destroy
    authorize @subscriber
    @question = @subscriber.question
    @subscriber.destroy!
  end

  private

  def find_subscriber
    @subscriber = Subscriber.find(params[:id])
  end

  def subscriber_params
    params.permit(:question_id)
  end
end