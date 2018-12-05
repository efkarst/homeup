class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.string :materials
      t.string :start_date
      t.string :due_date
      t.string :duration
      t.string :cost 
      t.string :status
      t.integer :room_id
      t.integer :shopping_list_id
    end
  end
end