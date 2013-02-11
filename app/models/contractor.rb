class Contractor < ActiveRecord::Base
  attr_accessible :address1, :address2, :city, :email, :fax, :name, :phone, :state, :zip

  belongs_to :company, foreign_key: 'company_token', primary_key: 'company_token'
  has_many :users
  
  before_save { |contractor| contractor.email = email.downcase }

  validates :company_token, presence: true  
  
  validates  :name, presence: true, length: {maximum: 70}
  validates  :address1, presence: true, length: {maximum: 30}
  validates  :city, presence: true, length: {maximum: 30}
  validates  :state, presence: true, length: {maximum: 2}
  validates  :zip, presence: true, length: {maximum: 10}
  validates  :email, presence: true, length: {maximum: 320}, format: { with: VALID_EMAIL_REGEX }
  validates  :phone, presence: true, length: {maximum: 10}  
  
  default_scope order: 'contractors.company_token'
end
