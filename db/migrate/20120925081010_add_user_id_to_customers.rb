class AddUserIdToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :user_id, :integer, default: 1
  end
end
