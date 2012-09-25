class AddUserIdToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :user_id, :integer, default: 1
  end
end
