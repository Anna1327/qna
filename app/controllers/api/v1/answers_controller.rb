# frozen_string_literal: true

class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_answer, only: %i[show update destroy]

  def show
    render json: @answer, serializer: AnswerSerializer
  end

  def create
    authorize Answer
    @answer = Answer.new(answer_params)
    @answer.author = current_user

    if @answer.save
      render json: @answer, serializer: AnswerSerializer
    else
      render json: @answer.errors.messages
    end
  end

  def update
    authorize @answer, :update?, policy_class: AnswerPolicy
    if @answer.update(answer_params)
      render json: @answer, serializer: AnswerSerializer
    else
      render json: @answer.errors.messages
    end
  end

  def destroy
    authorize @answer, :destroy?, policy_class: AnswerPolicy
    if @answer.destroy
      render json: { status: :ok }
    else
      render json: @answer.errors.messages
    end
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:question_id, :body, links_attributes: [:name, :url])
  end
end