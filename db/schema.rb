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

ActiveRecord::Schema.define(version: 20150630154450) do

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
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.float    "longitude"
    t.float    "latitude"
    t.string   "category"
    t.integer  "user_limit", default: 6
    t.boolean  "can_join",   default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.integer  "poster_id"
    t.boolean  "viewed",     default: false
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personal_messages", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_activities", force: :cascade do |t|
    t.integer "activity_id"
    t.integer "user_id"
  end

  create_table "user_groups", force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "password_digest", null: false
    t.string   "email",           null: false
    t.integer  "birth_day",       null: false
    t.integer  "birth_month",     null: false
    t.integer  "birth_year",      null: false
    t.string   "street",          null: false
    t.string   "city",            null: false
    t.string   "state",           null: false
    t.string   "category",        null: false
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
