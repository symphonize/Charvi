class Invoice < ActiveRecord::Base
  attr_accessible :company_address, :company_contact, :customer_address, :customer_contact, :customer_id, :due_date, :invoice_amount, :invoice_date, :status, :status_code, :start_date, :end_date
  attr_accessor :status_code
  
  belongs_to :company, foreign_key: 'company_token', primary_key: 'company_token'
  belongs_to :customer
  has_many :invoice_details
  
  before_create :populate_invoice_sequence
  before_save :set_invoice_status  
  
  validates :invoice_date, presence: true
  validates :due_date, presence: true  
  validates :start_date, presence: true
  validates :end_date, presence: true  
  
  def populate_invoice_sequence
    company.increment!(:invoice_sequence)
    self[:invoice_sequence] = company.invoice_sequence
    self[:invoice_no] = company.name[0..1].upcase + self[:invoice_date].strftime("%Y%m%d") + "-" + company.invoice_sequence.to_s
  end
    
  def to_param    
    self.invoice_sequence    
  end
  
  def status_code
    case self.status
      when 0 then "Created"
      when 1 then "Submitted"
      when 2 then "Reconciled"
    end
  end
  
  private
  
  def set_invoice_status
    self.status = case @status_code
                    when nil then 0
                    when "Created" then 0
                    when "Submitted" then 1
                    when "Reconciled" then 2
                  end  
  end 
  
  default_scope order: 'invoices.invoice_no desc'
end
