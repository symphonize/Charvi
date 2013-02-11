class RemoveCompanyIdFromProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :company_id
  end

  def down
    add_column :projects, :company_id
  end
end
