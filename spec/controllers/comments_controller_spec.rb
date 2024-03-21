# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create :user }
  let(:commented_author) { create :user }
  let(:commentable) { create(:question, author: commented_author) }

  describe 'POST #create', js: true do
    before { login(user) }

    context 'with valid attributes' do
      it "when create new comment" do
        expect do
          puts attributes_for(:comment, commentable: commentable, author: user)
          post :create,
                params: {
                  comment: {
                    body: 'New comment',
                    commentable_type: commentable.class.name,
                    commentable_id: commentable.id,
                    author_id: user.id
                  }
                },
                format: :json
        end.to change(commentable.comments, :count).by(1)
      end
    end
  end

  describe 'DELETE #destroy', js: true do
    before { login(user) }

    let(:comment) { create :comment, commentable: commentable, author: user }

    context "when user is comment's author" do
      it "deletes the comment" do
        create :comment, commentable: commentable, author: user
        expect do 
          delete :destroy,
            params: { id: comment.id }, format: :json
        end.to change(commentable.comments, :count).by(0)
      end
    end

    context "when user is not comment's author" do
      let(:other_user) { create :user }
      let(:other_question) { create :question, author: other_user }
      let(:comment) { create :comment, commentable: other_question, author: other_user }

      it "does not delete the comment" do
        create :comment, commentable: other_question, author: other_user

        expect do
          delete :destroy, 
            params: { id: comment.id }, format: :json
        end.not_to change(other_question.comments, :count)
      end
    end
  end
end
