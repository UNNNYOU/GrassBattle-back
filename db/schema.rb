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

ActiveRecord::Schema[7.0].define(version: 2024_07_11_082400) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "avatars", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "experience_histories", force: :cascade do |t|
    t.bigint "user_status_id", null: false
    t.integer "earned_experience_points", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_status_id"], name: "index_experience_histories_on_user_status_id"
  end

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
    t.integer "contribution_diff", default: 0, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_statuses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "MEMBER", null: false
    t.string "github_uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "avatar_id"
    t.index ["avatar_id"], name: "index_users_on_avatar_id"
    t.index ["github_uid"], name: "index_users_on_github_uid", unique: true
  end

  create_table "week_contribution_histories", force: :cascade do |t|
    t.bigint "user_status_id", null: false
    t.integer "week_contributions", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_status_id"], name: "index_week_contribution_histories_on_user_status_id"
  end

  add_foreign_key "experience_histories", "user_statuses"
  add_foreign_key "user_authentications", "users"
  add_foreign_key "user_statuses", "users"
  add_foreign_key "users", "avatars"
  add_foreign_key "week_contribution_histories", "user_statuses"
end
