class RemoveCompanyIdFromVendors < ActiveRecord::Migration
  def up
    remove_column :vendors, :company_id
  end

  def down
    add_column :vendors, :company_id, :integer
  end
end
