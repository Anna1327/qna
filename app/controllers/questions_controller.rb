# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def show
    @answer = question.answers.new
  end

  def new
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_user
    if @question.save
      redirect_to @question, notice: "Your question successfully created."
    else
      render :new
    end
  end

  def update
    question.update(question_params) if current_user.author_of?(question)
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path
    else
      redirect_to question, notice: t('.destroy.errors.other')
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
