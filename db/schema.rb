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

ActiveRecord::Schema.define(version: 20180817225326) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "checkins", force: :cascade do |t|
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

  create_table "client_flags", force: :cascade do |t|
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

  create_table "client_notes", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.text     "content"
    t.integer  "client_id"
    t.integer  "user_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.text     "rendered_content"
  end

  add_index "client_notes", ["client_id"], name: "index_client_notes_on_client_id", using: :btree
  add_index "client_notes", ["user_id"], name: "index_client_notes_on_user_id", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "current_alias",        limit: 255,                 null: false
    t.string   "full_name",            limit: 255
    t.text     "other_aliases"
    t.date     "oriented_on"
    t.integer  "point_balance",                    default: 0
    t.date     "birthday"
    t.string   "phone_number",         limit: 255
    t.text     "notes"
    t.integer  "added_by_id",                                      null: false
    t.integer  "last_edited_by_id"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.boolean  "is_active",                        default: true
    t.integer  "login_id"
    t.boolean  "is_flagged",                       default: false
    t.integer  "organization_id"
    t.string   "case_manager_info",    limit: 255
    t.text     "family_info"
    t.text     "community_goal"
    t.string   "email_address",        limit: 255
    t.string   "emergency_contact",    limit: 255
    t.text     "medical_info"
    t.text     "mailing_list_address"
    t.text     "personal_goal"
    t.boolean  "signed_covenant",                  default: false
    t.text     "staying_at"
    t.boolean  "on_mailing_list",                  default: false
    t.string   "checkin_code",         limit: 255
    t.date     "last_activity_on"
  end

  add_index "clients", ["added_by_id"], name: "index_clients_on_added_by_id", using: :btree
  add_index "clients", ["current_alias"], name: "index_clients_on_current_alias", unique: true, using: :btree
  add_index "clients", ["last_edited_by_id"], name: "index_clients_on_last_edited_by_id", using: :btree
  add_index "clients", ["login_id"], name: "index_clients_on_login_id", using: :btree
  add_index "clients", ["organization_id"], name: "index_clients_on_organization_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "name",         limit: 255, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "phone_number", limit: 255
    t.string   "address",      limit: 255
    t.string   "city",         limit: 255
    t.string   "state",        limit: 255
    t.string   "postal_code",  limit: 255
  end

  create_table "messages", force: :cascade do |t|
    t.text     "content"
    t.text     "rendered_content"
    t.integer  "author_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "title",            limit: 255
  end

  add_index "messages", ["author_id"], name: "index_messages_on_author_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name",                       limit: 255, null: false
    t.integer  "creator_id",                             null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "logo_file_name",             limit: 255
    t.string   "logo_content_type",          limit: 255
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "card_template_file_name",    limit: 255
    t.string   "card_template_content_type", limit: 255
    t.integer  "card_template_file_size"
    t.datetime "card_template_updated_at"
  end

  create_table "points_entries", force: :cascade do |t|
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

  create_table "points_entry_types", force: :cascade do |t|
    t.string   "name",           limit: 255,                null: false
    t.string   "description",    limit: 255
    t.integer  "default_points",             default: 0
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.boolean  "is_active",                  default: true
  end

  create_table "preferences", force: :cascade do |t|
    t.integer  "user_id",                                null: false
    t.string   "client_fields", limit: 255, default: [], null: false, array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "preferences", ["user_id"], name: "index_preferences_on_user_id", unique: true, using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], name: "index_roles_users_on_role_id", using: :btree
  add_index "roles_users", ["user_id"], name: "index_roles_users_on_user_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255, null: false
    t.text     "data"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "user_sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255, null: false
    t.text     "data"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "user_sessions", ["session_id"], name: "index_user_sessions_on_session_id", using: :btree
  add_index "user_sessions", ["updated_at"], name: "index_user_sessions_on_updated_at", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                limit: 255, default: ""
    t.string   "login",               limit: 255,              null: false
    t.string   "crypted_password",    limit: 255,              null: false
    t.string   "password_salt",       limit: 255,              null: false
    t.string   "email",               limit: 255, default: ""
    t.string   "persistence_token",   limit: 255,              null: false
    t.string   "single_access_token", limit: 255,              null: false
    t.string   "perishable_token",    limit: 255,              null: false
    t.integer  "login_count",                     default: 0,  null: false
    t.integer  "failed_login_count",              default: 0,  null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip",    limit: 255
    t.string   "last_login_ip",       limit: 255
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "last_message_check"
    t.integer  "organization_id"
  end

  add_index "users", ["organization_id"], name: "index_users_on_organization_id", using: :btree

end
