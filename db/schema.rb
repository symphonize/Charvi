# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130322205442) do

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "email"
    t.string   "website"
    t.string   "phone"
    t.string   "fax"
    t.string   "contact"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.string   "company_token",    :limit => nil
    t.integer  "invoice_sequence",                :default => 0
  end

  create_table "contractors", :force => true do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "email"
    t.string   "phone"
    t.string   "fax"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "company_token", :limit => nil
  end

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "email"
    t.string   "website"
    t.string   "phone"
    t.string   "fax"
    t.string   "contact"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "company_token", :limit => nil
  end

  create_table "invoice_details", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "contractor_id"
    t.integer  "time"
    t.decimal  "billing_amount"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "company_token",  :limit => nil
  end

  create_table "invoices", :force => true do |t|
    t.string   "invoice_no"
    t.integer  "customer_id"
    t.string   "customer_contact"
    t.string   "customer_address"
    t.string   "company_contact"
    t.string   "company_address"
    t.date     "invoice_date"
    t.date     "due_date"
    t.decimal  "invoice_amount"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "company_token",    :limit => nil
    t.integer  "status"
    t.integer  "invoice_sequence"
    t.date     "start_date"
    t.date     "end_date"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "manager"
    t.string   "email"
    t.string   "phone"
    t.integer  "customer_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "company_token", :limit => nil
  end

  create_table "resources", :force => true do |t|
    t.integer  "project_id"
    t.integer  "contractor_id"
    t.integer  "billing_type"
    t.decimal  "billing_amount"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "company_token",  :limit => nil
  end

  add_index "resources", ["project_id"], :name => "index_resources_on_project_id"

  create_table "timesheets", :force => true do |t|
    t.integer  "resource_id"
    t.integer  "time"
    t.string   "description"
    t.boolean  "overtime"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "status",                       :default => 0
    t.date     "day"
    t.string   "company_token", :limit => nil
  end

  add_index "timesheets", ["resource_id"], :name => "index_timesheets_on_resource_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "role",                           :default => "Owner"
    t.string   "company_token",   :limit => nil
    t.integer  "contractor_id"
    t.integer  "project_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "vendors", :force => true do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "email"
    t.string   "phone"
    t.string   "fax"
    t.string   "website"
    t.string   "contact"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "company_token", :limit => nil
  end

end
