# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update]

  def new
  end

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    answer.update(answer_params) if current_user.author_of?(answer)
  end

  def destroy
    question = answer.question
    if current_user.author_of?(answer)
      answer.destroy
      flash[:notice] = t('.success')
    else
      flash[:notice] = t('.destroy.error.other')
    end
    redirect_to question
  end

  private

  def answer
    @answer ||= Answer.find(params[:id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:body, :correct)
  end
end
