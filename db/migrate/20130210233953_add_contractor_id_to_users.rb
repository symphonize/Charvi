class AddContractorIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :contractor_id, :integer, default:nil
  end
end
