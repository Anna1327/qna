# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscriber, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author).class_name('User') }
end
