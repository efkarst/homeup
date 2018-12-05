class CreateShoppingList < ActiveRecord::Migration
  def change
    create_table :shopping_lists do |t|
      t.string :name
      t.integer :user_id
    end
  end
end
