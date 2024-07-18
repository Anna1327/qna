class CreateAuthorizations < ActiveRecord::Migration[6.1]
  def change
    create_table :authorizations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider
      t.string :uid
      t.string :confirmation_token, null: true
      t.timestamps
    end

    add_index :authorizations, %i[provider uid]
  end
end
