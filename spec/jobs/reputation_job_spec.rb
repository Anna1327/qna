# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReputationJob, type: :job do
  let(:question) { build(:question) }

  it 'calls Services::Reputation#calculate' do
    expect(Reputation).to have_received(:calculate).with(question)
    described_class.perform_now(question)
  end
end
