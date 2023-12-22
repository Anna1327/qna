class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :value, null: false
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :votable, polymorphic: true

      t.timestamps
    end
  end
end
