class RemoveCompanyIdFromContractors < ActiveRecord::Migration
  def up
    remove_column :contractors, :company_id
  end

  def down
    add_column :contractors, :company_id
  end
end
