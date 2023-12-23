require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:author).class_name('User') }
  it { should belong_to :votable }

  it { should validate_presence_of :value }
end
