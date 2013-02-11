class RemoveCompanyIdFromCustomers < ActiveRecord::Migration
  def up
    remove_column :customers, :company_id
  end

  def down
    add_column :customers, :company_id
  end
end
