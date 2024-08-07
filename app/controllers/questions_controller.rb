# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :question, only: %i[show edit update destroy]
  after_action :publish_question, only: [:create]

  def index
    authorize Question
    @questions = Question.all
  end

  def show
    authorize question
    @subscriber = Subscriber.find_by(author: current_user, question: question)
    @answer = question.answers.new
    @answer.links.build
    gon.push({
               current_user_id: current_user&.id,
               question_id: @question.id
             })
  end

  def new
    authorize Question
    @question = Question.new
    @question.links.build
    @reward = Reward.new(question: @question)
  end

  def edit; end

  def create
    authorize Question
    @question = current_user.questions.build(question_params)
    if @question.save
      @question.subscribers.create(author: current_user)
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    authorize question
    question.update(question_params) if current_user.author_of?(question)
  end

  def destroy
    authorize question
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path
    else
      redirect_to question, notice: t('.destroy.errors.other')
    end
  end

  private

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                                    links_attributes: %i[name url],
                                                    reward_attributes: %i[title image])
  end
end
