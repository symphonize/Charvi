class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.integer :project_id
      t.integer :contractor_id
      t.integer :billing_type
      t.decimal :billing_amount

      t.timestamps
    end
    add_index :resources, [:project_id]
  end
end
