class Customer < ActiveRecord::Base
  attr_accessible :address1, :address2, :city, :company_id, :contact, :email, :fax, :name, :phone, :state, :website, :zip
  belongs_to :company
  has_many :projects 
  
  before_save { |customer| customer.email = email.downcase }

  validates :company_id, presence: true
  
  
  validates  :name, presence: true, length: {maximum: 70}
  validates  :address1, presence: true, length: {maximum: 30}
  validates  :city, presence: true, length: {maximum: 30}
  validates  :state, presence: true, length: {maximum: 2}
  validates  :zip, presence: true, length: {maximum: 10}
  validates  :email, presence: true, length: {maximum: 320}, format: { with: VALID_EMAIL_REGEX }
  validates  :phone, presence: true, length: {maximum: 10}
  validates  :contact, presence: true, length: {maximum: 75}
  
  default_scope order: 'customers.company_id'
end
