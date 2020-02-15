class CreateListCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :list_categories do |t|
      t.integer :list_id
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
