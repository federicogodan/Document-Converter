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

ActiveRecord::Schema.define(:version => 20130926230159) do

  create_table "documents", :force => true do |t|
    t.string   "email"
    t.integer  "document_number"
    t.date     "creation_date"
    t.string   "name"
    t.boolean  "uploading"
    t.string   "original_extension"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "documents", ["email", "document_number"], :name => "index_documents_on_email_and_document_number"
  add_index "documents", ["email"], :name => "index_documents_on_email"

  create_table "documents_files", :force => true do |t|
    t.string   "email"
    t.integer  "document_number"
    t.string   "current_extension"
    t.string   "status"
    t.date     "conversion_end_date"
    t.integer  "size_in_bytes"
    t.string   "download_link"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "documents_files", ["email", "document_number", "current_extension"], :name => "index_on_documents_file_email_number_extension"

  create_table "registered_users", :force => true do |t|
    t.string   "email"
    t.string   "api_key"
    t.string   "secret_key"
    t.integer  "total_storage_assigned"
    t.integer  "documents_time_for_expiration"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.date     "registration_date"
    t.date     "last_acces"
    t.string   "profile_type"
    t.date     "last_access"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "webhooks", :force => true do |t|
    t.string   "email"
    t.string   "url"
    t.boolean  "deleted"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
