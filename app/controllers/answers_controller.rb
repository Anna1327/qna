# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, only: :create

  def new
  end

  def create
    @answer = question.answers.new(answer_params)
    if @answer.save
      redirect_to question, notice: t('answers.create.success')
    else
      render :new
    end
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:body, :correct)
  end
end
