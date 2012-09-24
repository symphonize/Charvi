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
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Company < ActiveRecord::Base
  attr_accessible :address1, :address2, :city, :contact, :email, :fax, :name, :phone, :state, :website, :zip
  has_many :customers, dependent: :destroy
  has_many :contractors, dependent: :destroy
  has_many :vendors, dependent: :destroy

  before_save { |company| company.email = email.downcase }
  
  validates  :address1, presence: true, length: {maximum: 30}
  validates  :city, presence: true, length: {maximum: 30}
  validates  :state, presence: true, length: {maximum: 2}
  validates  :zip, presence: true, length: {maximum: 10}
  validates  :email, presence: true, length: {maximum: 320}, format: { with: VALID_EMAIL_REGEX }
  validates  :phone, presence: true, length: {maximum: 10}
  validates  :contact, presence: true, length: {maximum: 75}
  
end
