# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  let(:service) { double('Notification') }
  let(:user) { create :user }
  let(:question) { create :question, author: user }
  let(:answer) { create :answer, question: question, author: user }

  before do
    allow(Notification).to receive(:new).and_return(service)
  end

  it 'calls Services::Notification#send_notification' do
    expect(service).to receive(:send_notification).with(answer)
    described_class.perform_now(answer)
  end
end
