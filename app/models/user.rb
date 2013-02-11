# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  company_token   :uuid
#  password_digest :string(255)
#  remember_token  :string(255)
#  role :string(255)

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :company_token, :role, :project_id, :contractor_id
  attr_protected :company_token
  has_secure_password
  
  belongs_to :company, foreign_key: 'company_token', primary_key: 'company_token'
  belongs_to :projects
  belongs_to :contractors
  
  before_save { |user| user.email = email.downcase }
  before_create :create_remember_token
  
  validates :name, length: { maximum: 50 }
  validates :role, presence: true, length: { maximum: 50 }
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, :presence     => true,
                     :confirmation => true,
                     :length       => { :minimum => 6 },
                     :if           => :password # only validate if password changed  
  
  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
