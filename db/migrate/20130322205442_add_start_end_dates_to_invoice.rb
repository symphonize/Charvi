class AddStartEndDatesToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :start_date, :date, default:nil
    add_column :invoices, :end_date, :date, default:nil
  end
end
