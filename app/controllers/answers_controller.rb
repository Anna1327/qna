# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: [:create, :update, :destroy, :mark_as_the_best]

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
    if current_user.author_of?(answer)
      answer.destroy
      flash[:notice] = t('.success')
    else
      flash[:notice] = t('.destroy.error.other')
    end
  end

  def mark_as_the_best
    @answer = Answer.find(params[:best_answer])
    @question = Question.find(params[:id])
    @answer.set_best_answer(@question) if current_user.author_of?(@question)
  end

  private

  def answer
    @answer ||= Answer.with_attached_files.find(params[:id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question, :answer

  def answer_params
    params.require(:answer).permit(:body, :correct, files: [], links_attributes: [:name, :url])
  end
end
