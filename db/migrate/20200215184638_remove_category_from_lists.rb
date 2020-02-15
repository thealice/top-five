class RemoveCategoryFromLists < ActiveRecord::Migration[5.2]
  def change
    remove_column :lists, :category, :string
  end
end
