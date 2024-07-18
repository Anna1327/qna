module FilesAttached
  extend ActiveSupport::Concern

  def files
    object.files.map { |file| rails_blob_path(file, only_path: true) }
  end
end