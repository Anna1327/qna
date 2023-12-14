require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of(:body) }

  it 'have many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
