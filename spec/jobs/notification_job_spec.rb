# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  let(:user) { create :user }
  let(:question) { create :question, author: user }
  let(:answer) { create :answer, question: question, author: user }

  it 'calls SubscriberNotificationMailer#send_notification' do
    expect(SubscriberNotificationMailer).to receive(:send_notification).with(answer).and_call_original
    described_class.perform_now(answer)
  end
end
