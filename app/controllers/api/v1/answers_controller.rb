# frozen_string_literal: true

class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_answer, only: %i[show update destroy]
  before_action :find_question, only: :index

  def index
    @answers = @question.answers
    render json: @answers, each_serializer: AnswersSerializer
  end

  def show
    render json: @answer, serializer: AnswerSerializer
  end

  def create
    authorize Answer
    @answer = current_user.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      render json: @answer, serializer: AnswerSerializer
    else
      render json: @answer.errors.messages
    end
  end

  def update
    authorize @answer
    if @answer.update(answer_params)
      render json: @answer, serializer: AnswerSerializer
    else
      render json: @answer.errors.messages
    end
  end

  def destroy
    authorize @answer
    if @answer.destroy
      render json: { status: :ok }
    else
      render json: @answer.errors.messages
    end
  end

  private

  def find_question
    @question ||= Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:question_id, :body, links_attributes: [:name, :url])
  end
end