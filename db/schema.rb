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

ActiveRecord::Schema.define(version: 20151117211550) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "proposer_id"
    t.datetime "appointment"
    t.string   "plan"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
    t.float    "longitude"
    t.float    "latitude"
    t.boolean  "well_attended", default: false
  end

  add_index "activities", ["group_id"], name: "index_activities_on_group_id", using: :btree
  add_index "activities", ["proposer_id"], name: "index_activities_on_proposer_id", using: :btree

  create_table "drop_user_votes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "voter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "drop_user_votes", ["group_id"], name: "index_drop_user_votes_on_group_id", using: :btree
  add_index "drop_user_votes", ["user_id"], name: "index_drop_user_votes_on_user_id", using: :btree
  add_index "drop_user_votes", ["voter_id"], name: "index_drop_user_votes_on_voter_id", using: :btree

  create_table "expand_group_votes", force: :cascade do |t|
    t.integer  "voter_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "expand_group_votes", ["group_id"], name: "index_expand_group_votes_on_group_id", using: :btree
  add_index "expand_group_votes", ["voter_id"], name: "index_expand_group_votes_on_voter_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.float    "longitude"
    t.float    "latitude"
    t.string   "category"
    t.integer  "user_limit",      default: 6
    t.boolean  "can_join",        default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "degree",          default: 1
    t.boolean  "ready_to_expand", default: false
    t.boolean  "has_expanded",    default: false
    t.string   "slug"
    t.string   "age_group"
    t.string   "gender_group"
  end

  add_index "groups", ["age_group"], name: "index_groups_on_age_group", using: :btree
  add_index "groups", ["gender_group"], name: "index_groups_on_gender_group", using: :btree
  add_index "groups", ["slug"], name: "index_groups_on_slug", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "poster_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "messageable_id"
    t.string   "messageable_type"
  end

  add_index "messages", ["poster_id"], name: "index_messages_on_poster_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.integer  "user_id"
    t.integer  "poster_id"
    t.boolean  "viewed",            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "notification_type"
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "surveys", force: :cascade do |t|
    t.string   "email"
    t.string   "reasons",    array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_activities", force: :cascade do |t|
    t.integer "activity_id"
    t.integer "user_id"
  end

  add_index "user_activities", ["activity_id", "user_id"], name: "index_user_activities_on_activity_id_and_user_id", using: :btree
  add_index "user_activities", ["activity_id"], name: "index_user_activities_on_activity_id", using: :btree
  add_index "user_activities", ["user_id"], name: "index_user_activities_on_user_id", using: :btree

  create_table "user_groups", force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
  end

  add_index "user_groups", ["group_id", "user_id"], name: "index_user_groups_on_group_id_and_user_id", using: :btree
  add_index "user_groups", ["group_id"], name: "index_user_groups_on_group_id", using: :btree
  add_index "user_groups", ["user_id"], name: "index_user_groups_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                                null: false
    t.string   "password_digest",                     null: false
    t.string   "email",                               null: false
    t.string   "category",                            null: false
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "last_sign_in_at"
    t.inet     "last_sign_in_ip"
    t.string   "auth_token"
    t.integer  "dropped_group_ids",      default: [],              array: true
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.integer  "group_limit",            default: 1
    t.string   "slug"
    t.string   "address"
    t.string   "age_group"
    t.string   "gender_group"
  end

  add_index "users", ["slug"], name: "index_users_on_slug", using: :btree

end
