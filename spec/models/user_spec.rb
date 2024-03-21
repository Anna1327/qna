require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards) }
  it { should have_many(:votes).class_name('Vote') }
  it { should have_many(:comments).class_name('Comment') }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
end
