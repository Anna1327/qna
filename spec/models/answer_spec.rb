require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like "votable"

  it { should belong_to(:question) }
  it { should have_many(:links).dependent(:destroy) }

  it { should have_one(:reward).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it { should validate_presence_of(:body) }

  it 'have many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
