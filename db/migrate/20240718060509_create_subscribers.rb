class CreateSubscribers < ActiveRecord::Migration[6.1]
  def change
    create_table :subscribers do |t|
      t.references :question, foreign_key: true
      t.references :author, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
