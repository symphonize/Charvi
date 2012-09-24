class Contractor < ActiveRecord::Base
  attr_accessible :address1, :address2, :city, :company_id, :email, :fax, :name, :phone, :state, :zip

  belongs_to :company
  before_save { |contractor| contractor.email = email.downcase }

  validates :company_id, presence: true
  
  
  validates  :address1, presence: true, length: {maximum: 30}
  validates  :city, presence: true, length: {maximum: 30}
  validates  :state, presence: true, length: {maximum: 2}
  validates  :zip, presence: true, length: {maximum: 10}
  validates  :email, presence: true, length: {maximum: 320}, format: { with: VALID_EMAIL_REGEX }
  validates  :phone, presence: true, length: {maximum: 10}  
  
  default_scope order: 'contractor.company_id'
end
