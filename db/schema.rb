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

ActiveRecord::Schema[8.1].define(version: 2026_08_09_120000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "analytics_snapshot_records", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "kafka_offset"
    t.string "projection_key", null: false
    t.jsonb "state", default: {}, null: false
    t.datetime "updated_at", null: false
    t.index ["projection_key"], name: "index_analytics_snapshot_records_on_projection_key", unique: true
  end

  create_table "message_records", id: :string, force: :cascade do |t|
    t.string "chat_id"
    t.text "content"
    t.datetime "created_at"
    t.json "embedding"
    t.string "receiver_id"
    t.string "sender_id"
  end
end
