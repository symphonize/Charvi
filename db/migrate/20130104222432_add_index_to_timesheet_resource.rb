class AddIndexToTimesheetResource < ActiveRecord::Migration
  def change
    add_index :timesheets, :resource_id, unique: false
  end
end
