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

ActiveRecord::Schema[8.0].define(version: 2025_06_25_215612) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "artists", force: :cascade do |t|
    t.string "name", null: false
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_artists_on_name", unique: true
  end

  create_table "artists_posters", force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.bigint "poster_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id", "poster_id"], name: "index_artists_posters_on_artist_id_and_poster_id", unique: true
    t.index ["artist_id"], name: "index_artists_posters_on_artist_id"
    t.index ["poster_id", "artist_id"], name: "index_artists_posters_on_poster_id_and_artist_id"
    t.index ["poster_id"], name: "index_artists_posters_on_poster_id"
  end

  create_table "bands", force: :cascade do |t|
    t.string "name", null: false
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_bands_on_name", unique: true
  end

  create_table "posters", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.date "release_date"
    t.decimal "original_price", precision: 8, scale: 2
    t.bigint "band_id"
    t.bigint "venue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "edition_size"
    t.json "visual_metadata"
    t.string "metadata_version"
    t.index ["band_id", "venue_id"], name: "index_posters_on_band_id_and_venue_id"
    t.index ["band_id"], name: "index_posters_on_band_id"
    t.index ["name"], name: "index_posters_on_name"
    t.index ["release_date", "band_id"], name: "index_posters_on_release_date_and_band_id"
    t.index ["release_date"], name: "index_posters_on_release_date"
    t.index ["venue_id"], name: "index_posters_on_venue_id"
  end

  create_table "posters_series", id: false, force: :cascade do |t|
    t.bigint "poster_id", null: false
    t.bigint "series_id", null: false
    t.index ["poster_id", "series_id"], name: "index_posters_series_on_poster_id_and_series_id", unique: true
    t.index ["series_id", "poster_id"], name: "index_posters_series_on_series_id_and_poster_id"
  end

  create_table "series", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "year"
    t.integer "total_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_series_on_name"
    t.index ["year"], name: "index_series_on_year"
  end

  create_table "user_posters", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "poster_id", null: false
    t.string "status", default: "watching", null: false
    t.string "edition_number"
    t.text "notes"
    t.decimal "purchase_price", precision: 8, scale: 2
    t.date "purchase_date"
    t.string "condition"
    t.boolean "for_sale", default: false
    t.decimal "asking_price", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "edition_type"
    t.index ["for_sale"], name: "index_user_posters_on_for_sale"
    t.index ["poster_id"], name: "index_user_posters_on_poster_id"
    t.index ["status"], name: "index_user_posters_on_status"
    t.index ["user_id", "poster_id"], name: "index_user_posters_on_user_id_and_poster_id"
    t.index ["user_id"], name: "index_user_posters_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "confirmed_at"
    t.string "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.string "otp_secret_key"
    t.datetime "otp_sent_at"
    t.datetime "otp_used_at"
    t.integer "otp_attempts_count", default: 0
    t.datetime "otp_locked_until"
    t.string "password_digest"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "failed_login_attempts", default: 0
    t.datetime "locked_until"
    t.datetime "last_login_at"
    t.string "provider"
    t.string "uid"
    t.json "provider_data"
    t.boolean "admin", default: false
    t.json "showcase_settings", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "bio"
    t.string "location"
    t.string "website"
    t.string "phone"
    t.date "collector_since"
    t.string "preferred_contact_method", default: "email"
    t.string "instagram_handle"
    t.string "twitter_handle"
    t.index ["collector_since"], name: "index_users_on_collector_since"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["location"], name: "index_users_on_location"
    t.index ["otp_secret_key"], name: "index_users_on_otp_secret_key", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "venues", force: :cascade do |t|
    t.string "name", null: false
    t.text "address"
    t.string "city"
    t.string "administrative_area"
    t.string "postal_code"
    t.string "country", default: "US"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "website"
    t.string "email"
    t.string "telephone_number"
    t.integer "capacity"
    t.string "venue_type", default: "other"
    t.string "status", default: "active"
    t.text "description"
    t.json "previous_names", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city", "administrative_area"], name: "index_venues_on_city_and_administrative_area"
    t.index ["country"], name: "index_venues_on_country"
    t.index ["latitude", "longitude"], name: "index_venues_on_latitude_and_longitude"
    t.index ["name"], name: "index_venues_on_name"
    t.index ["status"], name: "index_venues_on_status"
    t.index ["venue_type"], name: "index_venues_on_venue_type"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "artists_posters", "artists"
  add_foreign_key "artists_posters", "posters"
  add_foreign_key "posters", "bands"
  add_foreign_key "posters", "venues"
  add_foreign_key "posters_series", "posters"
  add_foreign_key "posters_series", "series"
  add_foreign_key "user_posters", "posters"
  add_foreign_key "user_posters", "users"
end
