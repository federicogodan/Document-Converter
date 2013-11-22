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

ActiveRecord::Schema.define(:version => 20131119020912) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
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
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "converted_documents", :force => true do |t|
    t.integer  "document_id"
    t.integer  "format_id"
    t.string   "download_link"
    t.integer  "status"
    t.integer  "size"
    t.datetime "conversion_end_date"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "documents", :force => true do |t|
    t.integer  "user_id"
    t.integer  "format_id"
    t.string   "file"
    t.string   "name"
    t.integer  "size"
    t.boolean  "expired"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "format_destinies", :force => true do |t|
    t.integer "format_id"
    t.integer "destiniy_id"
  end

  create_table "formats", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                         :default => "",       :null => false
    t.string   "encrypted_password",            :default => "",       :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                 :default => 0,        :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "profile_type"
    t.string   "name"
    t.string   "nick"
    t.string   "surname"
    t.string   "api_key"
    t.string   "secret_key"
    t.integer  "total_storage_assigned",        :default => 31457280, :null => false
    t.integer  "documents_time_for_expiration", :default => 86400,    :null => false
    t.integer  "bandwidth_in_bytes_per_sec",    :default => 0,        :null => false
    t.integer  "max_document_size",             :default => 10485760, :null => false
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "webhoooks", :force => true do |t|
    t.string   "url"
    t.boolean  "enabled"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "whsents", :force => true do |t|
    t.string   "url"
    t.string   "urldoc"
    t.integer  "state"
    t.integer  "attempts"
    t.integer  "webhoook_id"
    t.integer  "notification"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end
