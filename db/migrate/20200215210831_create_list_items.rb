class CreateListItems < ActiveRecord::Migration[5.2]
  def change
    create_table :list_items do |t|
      t.integer :rank
      t.text :content
      t.string :link
      t.integer :list_id

      t.timestamps null: false
    end
  end
end