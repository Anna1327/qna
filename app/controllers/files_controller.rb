# frozen_string_literal: true

class FilesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    file.purge if current_user.author_of?(file.record)
  end

  private

  def file
    @file ||= ActiveStorage::Attachment.find(params[:id])
  end
end
