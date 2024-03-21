# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :find_commentable, only: %i[destroy]

  after_action :publish_comment, only: %i[create]
  after_action :publish_delete_comment, only: %i[destroy]

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      render_json
    else
      render_errors
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment_id = @comment.id
    @comment.destroy

    respond_to do |format|
      format.json do
        render json: {
          status: 'success',
          comment_id: @comment_id
        }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :commentable_type, :commentable_id, :author_id)
  end

  def model_klass
    controller_name.classify.constantize
  end

  def find_commentable
    @commentable = model_klass.find(params[:id])
  end

  def render_json
    respond_to do |format|
      format.json do
        render json: {
          comment: @comment.as_json
        }
      end
    end
  end

  def render_errors
    respond_to do |format|
      format.json { render json: @comment.errors.full_messages, status: :unprocessable_entity }
    end
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast('comments', {
      action: 'create',
      comment: @comment.as_json,
      author: @comment.author.as_json
    })
  end

  def publish_delete_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast('comments', {
      action: 'delete',
      comment_id: @comment_id
    })
  end
end
