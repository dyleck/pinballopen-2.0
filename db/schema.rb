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

ActiveRecord::Schema.define(version: 20160507180455) do

  create_table "flippers", force: :cascade do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "translite_url"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "tournament_id"
  end

  add_index "flippers", ["tournament_id"], name: "index_flippers_on_tournament_id"

  create_table "matches", force: :cascade do |t|
    t.integer  "round_id"
    t.integer  "flipper_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "matches", ["flipper_id"], name: "index_matches_on_flipper_id"
  add_index "matches", ["round_id"], name: "index_matches_on_round_id"

  create_table "order_items", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "order_id"
    t.decimal  "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "size"
    t.decimal  "price"
  end

  add_index "order_items", ["product_id"], name: "index_order_items_on_product_id"

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "payed"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "payment_type"
    t.string   "locale"
    t.boolean  "payment_confirmed"
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "phases", force: :cascade do |t|
    t.string   "type"
    t.integer  "tournament_id"
    t.boolean  "fixed"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "number_of_rounds"
  end

  create_table "phases_users", force: :cascade do |t|
    t.integer "phase_id"
    t.integer "user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal  "sff_price"
  end

  create_table "rounds", force: :cascade do |t|
    t.integer  "phase_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "rounds", ["phase_id"], name: "index_rounds_on_phase_id"

  create_table "scores", force: :cascade do |t|
    t.integer  "match_id"
    t.integer  "user_id"
    t.integer  "value",      limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "scores", ["match_id"], name: "index_scores_on_match_id"
  add_index "scores", ["user_id"], name: "index_scores_on_user_id"

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "captain_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string   "name"
    t.integer  "number_of_machines"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "sff_member",        default: false
    t.boolean  "sff_validated",     default: false
    t.boolean  "admin",             default: false
    t.boolean  "activated",         default: false
    t.string   "activation_digest"
    t.string   "reset_digest"
    t.integer  "team_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["team_id"], name: "index_users_on_team_id"

end
