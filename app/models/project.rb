class Project < ActiveRecord::Base
  attr_accessible :company_id, :customer_id, :email, :manager, :name, :phone
  belongs_to :company
  belongs_to :customer
  
  has_many :resources
  
  before_save { |project| project.email = email.downcase }
  
  validates :company_id, presence: true
  validates :customer_id, presence: true
  
  validates  :name, presence: true, length: {maximum: 70}
  validates  :email, presence: true, length: {maximum: 320}, format: { with: VALID_EMAIL_REGEX }
  validates  :phone, presence: true, length: {maximum: 10}
  validates  :manager, presence: true, length: {maximum: 75}
  
  default_scope order: 'projects.company_id'
  
end
