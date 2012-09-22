# == Schema Information
#
# Table name: companies
#
#  id              :integer          not null, primary key
#  CompanyName     :string(255)
#  CompanyAddress1 :string(255)
#  CompanyAddress2 :string(255)
#  CompanyCity     :string(255)
#  CompanyState    :string(255)
#  CompanyZip      :string(255)
#  CompanyEmail    :string(255)
#  CompanyWebsite  :string(255)
#  CompanyPhone    :string(255)
#  CompanyFax      :string(255)
#  CompanyContact  :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Company do
  pending "add some examples to (or delete) #{__FILE__}"
end
