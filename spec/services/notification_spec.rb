# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification do
  let(:user) { create :user }
  let(:question) { create :question }
  let(:subscriber) { create :subscriber, author: user, question: question }
  let(:answer) { create :answer, question: question, author: user }

  it 'sends notification to subscriber' do
    expect(SubscriberNotificationMailer).to receive(:send_notification).with(answer).and_call_original
    subject.send_notification(answer)
  end

  it 'does not send notification to not subscriber' do
    answer = create :answer, question: question, author: user

    expect(SubscriberNotificationMailer).not_to receive(:send_notification).with(answer).and_call_original
  end
end
