class AddTimesheetDayToTimesheets < ActiveRecord::Migration
  def change
    add_column :timesheets, :timesheet_day, :date, default:nil
  end
end
