class DeleteShoppingList < ActiveRecord::Migration
  def change
    drop_table :shopping_lists
  end
end
