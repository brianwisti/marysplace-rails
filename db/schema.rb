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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140728211829) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "catalog_items", force: true do |t|
    t.string   "name"
    t.integer  "cost"
    t.text     "description"
    t.boolean  "is_available", default: true
    t.integer  "added_by_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "catalog_items", ["added_by_id"], name: "index_catalog_items_on_added_by_id", using: :btree

  create_table "checkins", force: true do |t|
    t.integer  "client_id"
    t.integer  "user_id"
    t.datetime "checkin_at"
    t.text     "notes"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "is_valid"
    t.integer  "location_id"
  end

  add_index "checkins", ["client_id"], name: "index_checkins_on_client_id", using: :btree
  add_index "checkins", ["location_id"], name: "checkins_location_index", using: :btree
  add_index "checkins", ["user_id"], name: "index_checkins_on_user_id", using: :btree

  create_table "client_flags", force: true do |t|
    t.integer  "client_id"
    t.integer  "created_by_id"
    t.text     "description"
    t.text     "consequence"
    t.text     "action_required"
    t.boolean  "is_blocking"
    t.date     "expires_on"
    t.integer  "resolved_by_id"
    t.date     "resolved_on"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.text     "resolution"
    t.boolean  "can_shop",        default: true
  end

  add_index "client_flags", ["client_id"], name: "index_client_flags_on_client_id", using: :btree
  add_index "client_flags", ["created_by_id"], name: "index_client_flags_on_created_by_id", using: :btree
  add_index "client_flags", ["resolved_by_id"], name: "index_client_flags_on_resolved_by_id", using: :btree

  create_table "client_notes", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "client_id"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "rendered_content"
  end

  add_index "client_notes", ["client_id"], name: "index_client_notes_on_client_id", using: :btree
  add_index "client_notes", ["user_id"], name: "index_client_notes_on_user_id", using: :btree

  create_table "clients", force: true do |t|
    t.string   "current_alias",                        null: false
    t.string   "full_name"
    t.text     "other_aliases"
    t.date     "oriented_on"
    t.integer  "point_balance",        default: 0
    t.date     "birthday"
    t.string   "phone_number"
    t.text     "notes"
    t.integer  "added_by_id",                          null: false
    t.integer  "last_edited_by_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.boolean  "is_active",            default: true
    t.integer  "login_id"
    t.boolean  "is_flagged",           default: false
    t.integer  "organization_id"
    t.string   "case_manager_info"
    t.text     "family_info"
    t.text     "community_goal"
    t.string   "email_address"
    t.string   "emergency_contact"
    t.text     "medical_info"
    t.text     "mailing_list_address"
    t.text     "personal_goal"
    t.boolean  "signed_covenant",      default: false
    t.text     "staying_at"
    t.boolean  "on_mailing_list",      default: false
    t.string   "checkin_code"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
  end

  add_index "clients", ["added_by_id"], name: "index_clients_on_added_by_id", using: :btree
  add_index "clients", ["current_alias"], name: "index_clients_on_current_alias", unique: true, using: :btree
  add_index "clients", ["last_edited_by_id"], name: "index_clients_on_last_edited_by_id", using: :btree
  add_index "clients", ["login_id"], name: "index_clients_on_login_id", using: :btree
  add_index "clients", ["organization_id"], name: "index_clients_on_organization_id", using: :btree

  create_table "locations", force: true do |t|
    t.string   "name",         null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "phone_number"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
  end

  create_table "messages", force: true do |t|
    t.text     "content"
    t.text     "rendered_content"
    t.integer  "author_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "title"
  end

  add_index "messages", ["author_id"], name: "index_messages_on_author_id", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name",                       null: false
    t.integer  "creator_id",                 null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "card_template_file_name"
    t.string   "card_template_content_type"
    t.integer  "card_template_file_size"
    t.datetime "card_template_updated_at"
  end

  create_table "points_entries", force: true do |t|
    t.integer  "client_id",                            null: false
    t.integer  "points_entry_type_id",                 null: false
    t.date     "performed_on",                         null: false
    t.boolean  "bailed",               default: false
    t.integer  "points",                               null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "added_by_id"
    t.boolean  "is_finalized",         default: true
    t.integer  "location_id"
    t.integer  "multiple",             default: 1
    t.integer  "points_entered",       default: 0
  end

  add_index "points_entries", ["added_by_id"], name: "index_points_entries_on_added_by_id", using: :btree
  add_index "points_entries", ["client_id"], name: "index_points_entries_on_client_id", using: :btree
  add_index "points_entries", ["location_id"], name: "points_entries_location_index", using: :btree
  add_index "points_entries", ["points_entry_type_id"], name: "index_points_entries_on_points_entry_type_id", using: :btree

  create_table "points_entry_types", force: true do |t|
    t.string   "name",                          null: false
    t.string   "description"
    t.integer  "default_points", default: 0
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "is_active",      default: true
  end

  create_table "preferences", force: true do |t|
    t.integer  "user_id",       null: false
    t.string   "client_fields"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "preferences", ["user_id"], name: "index_preferences_on_user_id", unique: true, using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles_users", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], name: "index_roles_users_on_role_id", using: :btree
  add_index "roles_users", ["user_id"], name: "index_roles_users_on_user_id", using: :btree

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "signup_entries", force: true do |t|
    t.integer  "signup_list_id"
    t.integer  "client_id"
    t.integer  "points_entry_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "signup_entries", ["client_id"], name: "index_signup_entries_on_client_id", using: :btree
  add_index "signup_entries", ["points_entry_id"], name: "index_signup_entries_on_points_entry_id", using: :btree
  add_index "signup_entries", ["signup_list_id"], name: "index_signup_entries_on_signup_list_id", using: :btree

  create_table "signup_lists", force: true do |t|
    t.integer  "points_entry_type_id"
    t.date     "signup_date"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "signup_lists", ["points_entry_type_id"], name: "index_signup_lists_on_points_entry_type_id", using: :btree

  create_table "store_cart_items", force: true do |t|
    t.integer  "store_cart_id"
    t.integer  "catalog_item_id"
    t.integer  "cost"
    t.string   "detail"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "store_cart_items", ["catalog_item_id"], name: "index_store_cart_items_on_catalog_item_id", using: :btree
  add_index "store_cart_items", ["store_cart_id"], name: "index_store_cart_items_on_store_cart_id", using: :btree

  create_table "store_carts", force: true do |t|
    t.integer  "shopper_id"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer  "handled_by_id"
    t.integer  "total"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "store_carts", ["handled_by_id"], name: "index_store_carts_on_handled_by_id", using: :btree
  add_index "store_carts", ["shopper_id"], name: "index_store_carts_on_shopper_id", using: :btree

  create_table "user_sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_sessions", ["session_id"], name: "index_user_sessions_on_session_id", using: :btree
  add_index "user_sessions", ["updated_at"], name: "index_user_sessions_on_updated_at", using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                default: ""
    t.string   "login",                            null: false
    t.string   "crypted_password",                 null: false
    t.string   "password_salt",                    null: false
    t.string   "email",               default: ""
    t.string   "persistence_token",                null: false
    t.string   "single_access_token",              null: false
    t.string   "perishable_token",                 null: false
    t.integer  "login_count",         default: 0,  null: false
    t.integer  "failed_login_count",  default: 0,  null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "last_message_check"
    t.integer  "organization_id"
  end

  add_index "users", ["organization_id"], name: "index_users_on_organization_id", using: :btree

end
