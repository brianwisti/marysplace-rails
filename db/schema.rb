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

ActiveRecord::Schema.define(:version => 20130602063915) do

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

  create_table "checkins", :force => true do |t|
    t.integer  "client_id"
    t.integer  "user_id"
    t.datetime "checkin_at"
    t.text     "notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "is_valid"
  end

  add_index "checkins", ["client_id"], :name => "index_checkins_on_client_id"
  add_index "checkins", ["user_id"], :name => "index_checkins_on_user_id"

  create_table "client_flags", :force => true do |t|
    t.integer  "client_id"
    t.integer  "created_by_id"
    t.text     "description"
    t.text     "consequence"
    t.text     "action_required"
    t.boolean  "is_blocking"
    t.date     "expires_on"
    t.integer  "resolved_by_id"
    t.date     "resolved_on"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "resolution"
  end

  add_index "client_flags", ["client_id"], :name => "index_client_flags_on_client_id"

  create_table "clients", :force => true do |t|
    t.string   "current_alias",                        :null => false
    t.string   "full_name"
    t.text     "other_aliases"
    t.date     "oriented_on"
    t.integer  "point_balance",     :default => 0
    t.date     "birthday"
    t.string   "phone_number"
    t.text     "notes"
    t.integer  "added_by_id",                          :null => false
    t.integer  "last_edited_by_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "is_active",         :default => true
    t.integer  "login_id"
    t.boolean  "is_flagged",        :default => false
  end

  create_table "points_entries", :force => true do |t|
    t.integer  "client_id",                               :null => false
    t.integer  "points_entry_type_id",                    :null => false
    t.date     "performed_on",                            :null => false
    t.boolean  "bailed",               :default => false
    t.integer  "points",                                  :null => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "added_by_id"
    t.boolean  "is_finalized",         :default => true
  end

  add_index "points_entries", ["client_id"], :name => "index_points_entries_on_client_id"
  add_index "points_entries", ["points_entry_type_id"], :name => "index_points_entries_on_points_entry_type_id"

  create_table "points_entry_types", :force => true do |t|
    t.string   "name",                             :null => false
    t.string   "description"
    t.integer  "default_points", :default => 0
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.boolean  "is_active",      :default => true
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "signup_entries", :force => true do |t|
    t.integer  "signup_list_id"
    t.integer  "client_id"
    t.integer  "points_entry_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "signup_lists", :force => true do |t|
    t.integer  "points_entry_type_id"
    t.date     "signup_date"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "user_sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_sessions", ["session_id"], :name => "index_user_sessions_on_session_id"
  add_index "user_sessions", ["updated_at"], :name => "index_user_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "name",                :default => ""
    t.string   "login",                               :null => false
    t.string   "crypted_password",                    :null => false
    t.string   "password_salt",                       :null => false
    t.string   "email",               :default => ""
    t.string   "persistence_token",                   :null => false
    t.string   "single_access_token",                 :null => false
    t.string   "perishable_token",                    :null => false
    t.integer  "login_count",         :default => 0,  :null => false
    t.integer  "failed_login_count",  :default => 0,  :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

end
