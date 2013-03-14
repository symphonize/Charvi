class InvoiceDetail < ActiveRecord::Base
  attr_accessible :billing_amount, :contractor_id, :invoice_id, :time
  
  belongs_to :invoice
  
end
