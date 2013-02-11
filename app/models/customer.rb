class Customer < ActiveRecord::Base
  attr_accessible :address1, :address2, :city, :contact, :email, :fax, :name, :phone, :state, :website, :zip
  belongs_to :company, foreign_key: 'company_token', primary_key: 'company_token'
  has_many :projects 
  
  before_save { |customer| customer.email = email.downcase }

  validates  :name, presence: true, length: {maximum: 70}
  validates  :address1, presence: true, length: {maximum: 30}
  validates  :city, presence: true, length: {maximum: 30}
  validates  :state, presence: true, length: {maximum: 2}
  validates  :zip, presence: true, length: {maximum: 10}
  validates  :email, presence: true, length: {maximum: 320}, format: { with: VALID_EMAIL_REGEX }
  validates  :phone, presence: true, length: {maximum: 10}
  validates  :contact, presence: true, length: {maximum: 75}
  
  default_scope order: 'customers.company_token'
end
