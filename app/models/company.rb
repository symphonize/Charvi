# == Schema Information
#
# Table name: companies
#
#  id              :integer          not null, primary key
#  name     :string(255)
#  address1 :string(255)
#  address2 :string(255)
#  city     :string(255)
#  state    :string(255)
#  zip      :string(255)
#  email    :string(255)
#  website  :string(255)
#  phone    :string(255)
#  fax      :string(255)
#  contact  :string(255)
#  company_token   :uuid
#  company_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Company < ActiveRecord::Base
  attr_accessible :address1, :address2, :city, :contact, :email, :fax, :name, :phone, :state, :website, :zip, :company_token, :user
  
  has_many :users, dependent: :destroy, foreign_key: 'company_token', primary_key: 'company_token'
  accepts_nested_attributes_for :users  
  has_many :customers, foreign_key: 'company_token', primary_key: 'company_token', dependent: :destroy
  has_many :contractors, foreign_key: 'company_token', primary_key: 'company_token', dependent: :destroy
  has_many :vendors, foreign_key: 'company_token', primary_key: 'company_token', dependent: :destroy
  has_many :projects, dependent: :destroy

  before_save { |company| company.email = email.downcase unless company.email == nil }
  
  validates  :name, presence: true, length: {maximum: 70}
  validates  :address1, length: {maximum: 30}
  validates  :city, length: {maximum: 30}
  validates  :state, length: {maximum: 2}
  validates  :zip, length: {maximum: 10}
  validates  :email, allow_blank: true, length: {maximum: 320}, format: { with: VALID_EMAIL_REGEX }
  validates  :phone, presence: true, length: {maximum: 10}
  validates  :contact, presence: true, length: {maximum: 75}
  
  def user=(user)   
      user[:role] = 'Owner'
      user[:name] = self.contact   
      users.build(user)
  end
end
