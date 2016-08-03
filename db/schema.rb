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

ActiveRecord::Schema.define(version: 20160803145907) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendances", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "trip_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "attendances", ["trip_id"], name: "index_attendances_on_trip_id", using: :btree
  add_index "attendances", ["user_id"], name: "index_attendances_on_user_id", using: :btree

  create_table "attraction_suggestions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "attraction_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "attraction_suggestions", ["attraction_id"], name: "index_attraction_suggestions_on_attraction_id", using: :btree
  add_index "attraction_suggestions", ["user_id"], name: "index_attraction_suggestions_on_user_id", using: :btree

  create_table "attraction_tags", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "attraction_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "attraction_tags", ["attraction_id"], name: "index_attraction_tags_on_attraction_id", using: :btree
  add_index "attraction_tags", ["tag_id"], name: "index_attraction_tags_on_tag_id", using: :btree

  create_table "attractions", force: :cascade do |t|
    t.string   "eventful_id"
    t.integer  "city_id"
    t.string   "city_name"
    t.string   "country_name"
    t.string   "title"
    t.string   "description"
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

  create_table "tags", force: :cascade do |t|
    t.string   "tag"
    t.integer  "usages"
    t.integer  "relative_usage"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "trips", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "city_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "trips", ["city_id"], name: "index_trips_on_city_id", using: :btree
  add_index "trips", ["user_id"], name: "index_trips_on_user_id", using: :btree

  create_table "user_attractions", force: :cascade do |t|
    t.integer  "attraction_id"
    t.integer  "user_id"
    t.boolean  "like"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "user_attractions", ["attraction_id"], name: "index_user_attractions_on_attraction_id", using: :btree
  add_index "user_attractions", ["user_id"], name: "index_user_attractions_on_user_id", using: :btree

  create_table "user_tags", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "user_id"
    t.boolean  "like"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_tags", ["tag_id"], name: "index_user_tags_on_tag_id", using: :btree
  add_index "user_tags", ["user_id"], name: "index_user_tags_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",           null: false
    t.string   "token",           null: false
    t.string   "password_digest", null: false
    t.boolean  "admin",           null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["token"], name: "index_users_on_token", unique: true, using: :btree

  add_foreign_key "attendances", "trips"
  add_foreign_key "attendances", "users"
  add_foreign_key "attraction_suggestions", "attractions"
  add_foreign_key "attraction_suggestions", "users"
  add_foreign_key "attraction_tags", "attractions"
  add_foreign_key "attraction_tags", "tags"
  add_foreign_key "examples", "users"
  add_foreign_key "trips", "cities"
  add_foreign_key "trips", "users"
  add_foreign_key "user_attractions", "attractions"
  add_foreign_key "user_attractions", "users"
  add_foreign_key "user_tags", "tags"
  add_foreign_key "user_tags", "users"
end
