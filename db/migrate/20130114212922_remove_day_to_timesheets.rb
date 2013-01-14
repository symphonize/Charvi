class RemoveDayToTimesheets < ActiveRecord::Migration
  def up
    remove_column :timesheets, :day
  end

  def down
    add_column :timesheets, :day
  end
end
