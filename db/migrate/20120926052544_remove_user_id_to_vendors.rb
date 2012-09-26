class RemoveUserIdToVendors < ActiveRecord::Migration
  def up
    remove_column :vendors, :user_id
  end
end
