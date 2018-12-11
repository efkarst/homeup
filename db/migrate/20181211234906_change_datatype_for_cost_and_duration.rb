class ChangeDatatypeForCostAndDuration < ActiveRecord::Migration
  def change
    change_column :projects, :cost, :integer
    change_column :projects, :duration, :integer
  end
end
