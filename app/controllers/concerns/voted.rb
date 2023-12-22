module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, :find_vote, only: %i[liked disliked]
  end

  def liked
    if @vote.nil?
      create_vote(1)
    else
      vote_already_exists('liked')
    end
  end

  def disliked
    if @vote.nil?
      create_vote(-1)
    else
      vote_already_exists('disliked')
    end
  end

  private

  def create_vote(value)
    @vote = @votable.votes.build(author: current_user, value: value)
    if @vote.save
      render_html
    else
      render_errors
    end
  end

  def vote_already_exists(action)
    if current_user.author_of?(@votable)
      @vote.validation_by_author
      current_user.errors
    else
      @vote.send(action)
    end

    render_html
  end

  def model_klass
    controller_name.classify.constantize
  end

  def find_votable
    @votable = model_klass.find(params[:id])
  end

  def find_vote
    @vote = @votable.votes.find_by(author: current_user) || nil
  end

  def render_html
    respond_to do |format|
      format.html { render partial: 'votes/vote', locals: { resource: @votable } }
    end
  end

  def render_errors
    respond_to do |format|
      format.html do
        render partial: 'shared/errors',
          locals: { resource: @votable },
          status: :unprocessable_entity
      end
    end
  end
end