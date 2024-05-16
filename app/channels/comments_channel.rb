# frozen_string_literal: true

class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "question_#{params[:question_id]}_comment"
  end
end