class AddConfirmToAuthorization < ActiveRecord::Migration[6.1]
  def change
    add_column :authorizations, :confirm, :boolean, default: false
  end
end
