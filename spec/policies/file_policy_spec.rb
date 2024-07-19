# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FilePolicy, type: :policy do
  let(:user) { create :user }
  let(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
  let(:question) { create :question, author: user, files: [file] }
  let(:other_user) { create :user }
  let(:other_question) { create :question, author: other_user, files: [file] }

  subject { described_class }

  permissions :destroy? do
    it 'grants access if user is author of file' do
      expect(subject).to permit(user, question.files.first.record)
    end

    it 'denies access if user is not author of file' do
      expect(subject).not_to permit(user, other_question.files.first.record)
    end
  end
end
