class AddCompanyTokenToTimesheets < ActiveRecord::Migration
  def change
    add_column :timesheets, :company_token, :uuid
  end
end
