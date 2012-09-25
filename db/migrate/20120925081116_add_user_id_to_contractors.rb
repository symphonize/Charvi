class AddUserIdToContractors < ActiveRecord::Migration
  def change
    add_column :contractors, :user_id, :integer, default: 1
  end
end
