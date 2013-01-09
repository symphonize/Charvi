class CreateTimesheets < ActiveRecord::Migration
  def change
    create_table :timesheets do |t|
      t.integer :resource_id
      t.datetime :day
      t.integer :time
      t.string :description
      t.boolean :overtime

      t.timestamps
    end
  end
end
