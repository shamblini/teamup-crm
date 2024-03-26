# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_03_25_000437) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", null: false
    t.string "full_name"
    t.string "uid"
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "name"
    t.decimal "goal_amount"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "group_id"
    t.index ["group_id"], name: "index_campaigns_on_group_id"
  end

  create_table "donations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "amount"
    t.string "donor_name"
    t.datetime "donation_date"
    t.integer "campaign_id"
    t.integer "user_id"
  end

  create_table "filters", force: :cascade do |t|
    t.bigint "segment_id", null: false
    t.string "attribute_type"
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["segment_id"], name: "index_filters_on_segment_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "org_type"
  end

  create_table "logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "segments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "filters"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "user_type", default: "Volunteer/Donor"
    t.bigint "donations_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "logs_id"
    t.bigint "group_id"
    t.boolean "is_admin", default: false
    t.index ["donations_id"], name: "index_users_on_donations_id"
    t.index ["email"], name: "index_users_on_email"
    t.index ["group_id"], name: "index_users_on_group_id"
    t.index ["logs_id"], name: "index_users_on_logs_id"
  end

  add_foreign_key "filters", "segments"
  add_foreign_key "campaigns", "groups"
  add_foreign_key "logs", "users"
  add_foreign_key "users", "donations", column: "donations_id"
  add_foreign_key "users", "groups"
  add_foreign_key "users", "logs", column: "logs_id"
end
