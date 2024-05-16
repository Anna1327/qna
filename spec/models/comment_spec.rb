# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:author).class_name('User') }
  it { should belong_to :commentable }

  it { should validate_presence_of :body }
end