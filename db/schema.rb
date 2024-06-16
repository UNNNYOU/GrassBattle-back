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

ActiveRecord::Schema[7.0].define(version: 2024_06_15_050926) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "user_authentications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_user_authentications_on_uid", unique: true
    t.index ["user_id"], name: "index_user_authentications_on_user_id"
  end

  create_table "user_statuses", force: :cascade do |t|
    t.integer "level", default: 1, null: false
    t.integer "experience_points", default: 0, null: false
    t.integer "week_contributions", default: 0, null: false
    t.integer "temporal_contribution_data", default: 0, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_statuses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "GRASS BATTLE MEMBER", null: false
    t.string "github_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["github_id"], name: "index_users_on_github_id", unique: true
  end

  add_foreign_key "user_authentications", "users"
  add_foreign_key "user_statuses", "users"
end
