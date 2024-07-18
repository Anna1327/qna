# frozen_string_literal: true

class ReputationJob < ApplicationJob
  queue_as :default

  def perform(object)
    Reputation.calculate(object)
  end
end
