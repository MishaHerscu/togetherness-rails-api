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

ActiveRecord::Schema.define(version: 20170312053927) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendances", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "trip_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "attendances", ["trip_id", "user_id"], name: "index_attendances_on_trip_id_and_user_id", unique: true, using: :btree
  add_index "attendances", ["trip_id"], name: "index_attendances_on_trip_id", using: :btree
  add_index "attendances", ["user_id"], name: "index_attendances_on_user_id", using: :btree

  create_table "attraction_categories", force: :cascade do |t|
    t.integer  "attraction_id"
    t.integer  "category_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "attraction_categories", ["attraction_id"], name: "index_attraction_categories_on_attraction_id", using: :btree
  add_index "attraction_categories", ["category_id"], name: "index_attraction_categories_on_category_id", using: :btree

  create_table "attraction_suggestions", force: :cascade do |t|
    t.integer  "user_id",       null: false
    t.integer  "attraction_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "attraction_suggestions", ["attraction_id", "user_id"], name: "index_attraction_suggestions_on_attraction_id_and_user_id", unique: true, using: :btree
  add_index "attraction_suggestions", ["attraction_id"], name: "index_attraction_suggestions_on_attraction_id", using: :btree
  add_index "attraction_suggestions", ["user_id"], name: "index_attraction_suggestions_on_user_id", using: :btree

  create_table "attractions", force: :cascade do |t|
    t.string   "eventful_id"
    t.string   "categories_string"
    t.integer  "city_id"
    t.string   "city_name"
    t.string   "country_name"
    t.string   "title"
    t.string   "description"
    t.string   "keywords_string"
    t.string   "owner"
    t.datetime "db_start_time"
    t.datetime "db_stop_time"
    t.string   "event_date"
    t.string   "event_time"
    t.string   "event_time_zone"
    t.integer  "all_day"
    t.string   "venue_id"
    t.string   "venue_name"
    t.string   "venue_address"
    t.integer  "postal_code"
    t.string   "venue_url"
    t.string   "geocode_type"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "image_information"
    t.string   "medium_image_url"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.string   "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "examples", force: :cascade do |t|
    t.text     "text",       null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "examples", ["user_id"], name: "index_examples_on_user_id", using: :btree

  create_table "friend_requests", force: :cascade do |t|
    t.integer  "user_id",           null: false
    t.integer  "requested_user_id", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "friend_requests", ["requested_user_id", "user_id"], name: "index_friend_requests_on_requested_user_id_and_user_id", unique: true, using: :btree
  add_index "friend_requests", ["user_id"], name: "index_friend_requests_on_user_id", using: :btree

  create_table "friendships", force: :cascade do |t|
    t.integer  "user_id",           null: false
    t.integer  "requested_user_id", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "friendships", ["requested_user_id", "user_id"], name: "index_friendships_on_requested_user_id_and_user_id", unique: true, using: :btree
  add_index "friendships", ["user_id"], name: "index_friendships_on_user_id", using: :btree

  create_table "trips", force: :cascade do |t|
    t.string   "name"
    t.string   "notes"
    t.integer  "user_id"
    t.integer  "city_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "trips", ["city_id", "user_id"], name: "index_trips_on_city_id_and_user_id", using: :btree
  add_index "trips", ["city_id"], name: "index_trips_on_city_id", using: :btree
  add_index "trips", ["user_id"], name: "index_trips_on_user_id", using: :btree

  create_table "user_attractions", force: :cascade do |t|
    t.integer  "attraction_id", null: false
    t.integer  "user_id",       null: false
    t.boolean  "like"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "user_attractions", ["attraction_id", "user_id"], name: "index_user_attractions_on_attraction_id_and_user_id", unique: true, using: :btree
  add_index "user_attractions", ["attraction_id"], name: "index_user_attractions_on_attraction_id", using: :btree
  add_index "user_attractions", ["user_id"], name: "index_user_attractions_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",           null: false
    t.string   "token",           null: false
    t.string   "password_digest", null: false
    t.boolean  "admin",           null: false
    t.string   "givenname",       null: false
    t.string   "surname",         null: false
    t.string   "keywords_string"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["token"], name: "index_users_on_token", unique: true, using: :btree

  add_foreign_key "attendances", "trips"
  add_foreign_key "attendances", "users"
  add_foreign_key "attraction_categories", "attractions"
  add_foreign_key "attraction_categories", "categories"
  add_foreign_key "attraction_suggestions", "attractions"
  add_foreign_key "attraction_suggestions", "users"
  add_foreign_key "examples", "users"
  add_foreign_key "friend_requests", "users"
  add_foreign_key "friendships", "users"
  add_foreign_key "trips", "cities"
  add_foreign_key "trips", "users"
  add_foreign_key "user_attractions", "attractions"
  add_foreign_key "user_attractions", "users"
end
