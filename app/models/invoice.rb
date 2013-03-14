class Invoice < ActiveRecord::Base
  attr_accessible :company_address, :company_contact, :customer_address, :customer_contact, :customer_id, :due_date, :invoice_amount, :invoice_date, :status
  belongs_to :company, foreign_key: 'company_token', primary_key: 'company_token'
  has_many :invoice_details
  belongs_to :customer
  
  before_create :populate_invoice_sequence
  
  def populate_invoice_sequence
    company.increment!(:invoice_sequence)
    self[:invoice_sequence] = company.invoice_sequence
    self[:invoice_no] = company.name[0..1].upcase + self[:invoice_date].strftime("%Y%m%d") + "-" + company.invoice_sequence.to_s
  end
    
  def to_param    
    self.invoice_sequence    
  end
  
  default_scope order: 'invoices.invoice_no desc'
end
