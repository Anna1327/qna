# frozen_string_literal: true

class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: %i[show answers update destroy]

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question, serializer: QuestionSerializer
  end

  def answers
    render json: @question.answers, each_serializer: AnswersSerializer
  end

  def create
    authorize Question
    @question = current_user.questions.build(question_params)

    if @question.save
      render json: @question, serializer: QuestionSerializer
    else
      render json: @question.errors.messages
    end
  end

  def update
    authorize @question, :update?, policy_class: QuestionPolicy
    if @question.update(question_params)
      render json: @question, serializer: QuestionSerializer
    else
      render json: @question.errors.messages
    end
  end

  def destroy
    authorize @question, :destroy?, policy_class: QuestionPolicy
    if @question.destroy
      render json: { status: :ok }
    else
      render json: @question.errors.messages
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: [:name, :url])
  end
end