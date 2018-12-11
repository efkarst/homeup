class DeleteDatesFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :start_date, :string
    remove_column :projects, :due_date, :string
  end
end
