class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.string :title
      t.string :category_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end