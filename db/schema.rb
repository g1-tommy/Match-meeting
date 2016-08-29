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

ActiveRecord::Schema.define(version: 20160820133137) do

  create_table "groups", force: :cascade do |t|
    t.string   "school"
    t.string   "name"
    t.text     "content"
    t.integer  "member"
    t.text     "affiliation"
    t.string   "creator"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "owners", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "phone"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "owners", ["email"], name: "index_owners_on_email", unique: true
  add_index "owners", ["reset_password_token"], name: "index_owners_on_reset_password_token", unique: true

  create_table "places", force: :cascade do |t|
    t.string   "name"
    t.text     "content"
    t.string   "creator"
    t.string   "location"
    t.integer  "open"
    t.integer  "close"
    t.integer  "likes"
    t.string   "who_likes_it"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.integer  "place_id"
    t.integer  "group_id"
    t.datetime "schedule"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "duration"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "timetables", force: :cascade do |t|
    t.string   "mon_time_09"
    t.string   "mon_time_10"
    t.string   "mon_time_11"
    t.string   "mon_time_12"
    t.string   "mon_time_13"
    t.string   "mon_time_14"
    t.string   "mon_time_15"
    t.string   "mon_time_16"
    t.string   "mon_time_17"
    t.string   "mon_time_18"
    t.string   "mon_time_19"
    t.string   "tue_time_09"
    t.string   "tue_time_10"
    t.string   "tue_time_11"
    t.string   "tue_time_12"
    t.string   "tue_time_13"
    t.string   "tue_time_14"
    t.string   "tue_time_15"
    t.string   "tue_time_16"
    t.string   "tue_time_17"
    t.string   "tue_time_18"
    t.string   "tue_time_19"
    t.string   "wed_time_09"
    t.string   "wed_time_10"
    t.string   "wed_time_11"
    t.string   "wed_time_12"
    t.string   "wed_time_13"
    t.string   "wed_time_14"
    t.string   "wed_time_15"
    t.string   "wed_time_16"
    t.string   "wed_time_17"
    t.string   "wed_time_18"
    t.string   "wed_time_19"
    t.string   "thu_time_09"
    t.string   "thu_time_10"
    t.string   "thu_time_11"
    t.string   "thu_time_12"
    t.string   "thu_time_13"
    t.string   "thu_time_14"
    t.string   "thu_time_15"
    t.string   "thu_time_16"
    t.string   "thu_time_17"
    t.string   "thu_time_18"
    t.string   "thu_time_19"
    t.string   "fri_time_09"
    t.string   "fri_time_10"
    t.string   "fri_time_11"
    t.string   "fri_time_12"
    t.string   "fri_time_13"
    t.string   "fri_time_14"
    t.string   "fri_time_15"
    t.string   "fri_time_16"
    t.string   "fri_time_17"
    t.string   "fri_time_18"
    t.string   "fri_time_19"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "phone"
    t.string   "school",                 default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
