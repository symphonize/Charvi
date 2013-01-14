class RemoveTimesheetDayToTimesheets < ActiveRecord::Migration
  def up
    remove_column :timesheets, :timesheet_day
  end

  def down
    add_column :timesheets, :timesheet_day
  end
end
