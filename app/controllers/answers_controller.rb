# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: %i[create update destroy mark_as_the_best]

  after_action :publish_answer, only: [:create]

  def new; end

  def create
    authorize Answer
    @answer = question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    authorize answer
    answer.update(answer_params) if current_user.author_of?(answer)
  end

  def destroy
    authorize answer
    if current_user.author_of?(answer)
      answer.destroy
      flash[:notice] = t('.success')
    else
      flash[:notice] = t('.destroy.error.other')
    end
  end

  def mark_as_the_best
    authorize answer
    @answer = Answer.find(params[:best_answer])
    @question = Question.find(params[:id])
    @answer.set_best_answer(@question) if current_user.author_of?(@question)
  end

  private

  def publish_answer
    return if @answer.errors.any?

    gon.push({
               answer_owner: answer.author.id,
               question_owner: @question.author.id
             })

    ActionCable.server.broadcast(
      "question_#{@answer.question.id}_answers",
      {
        answer: @answer.as_json,
        author: @answer.author.as_json,
        vote_count: @answer.vote_count
      }.as_json
    )
  end

  def answer
    @answer ||= Answer.with_attached_files.find(params[:id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question, :answer

  def answer_params
    params.require(:answer).permit(:body, :correct, files: [], links_attributes: %i[name url])
  end
end
