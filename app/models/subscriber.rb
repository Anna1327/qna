# frozen_string_literal: true

class Subscriber < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'
end
