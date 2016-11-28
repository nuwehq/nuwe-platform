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

ActiveRecord::Schema.define(version: 20160617125309) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "hstore"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "achievements", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "achievements", ["team_id"], name: "index_achievements_on_team_id", using: :btree

  create_table "alerts", force: :cascade do |t|
    t.string   "text",           null: false
    t.integer  "application_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "engine"
  end

  add_index "alerts", ["application_id"], name: "index_alerts_on_application_id", using: :btree

  create_table "apps", force: :cascade do |t|
    t.string   "provider",    limit: 255,             null: false
    t.string   "uid",         limit: 255,             null: false
    t.hstore   "info"
    t.hstore   "credentials"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",                default: 0, null: false
  end

  add_index "apps", ["user_id"], name: "index_apps_on_user_id", using: :btree

  create_table "capabilities", force: :cascade do |t|
    t.integer  "service_id"
    t.integer  "application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remote_application_key"
    t.string   "remote_application_secret"
  end

  add_index "capabilities", ["application_id"], name: "index_capabilities_on_application_id", using: :btree
  add_index "capabilities", ["service_id"], name: "index_capabilities_on_service_id", using: :btree

  create_table "collaborations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collaborations", ["application_id"], name: "index_collaborations_on_application_id", using: :btree
  add_index "collaborations", ["user_id"], name: "index_collaborations_on_user_id", using: :btree

  create_table "column_values", force: :cascade do |t|
    t.string   "field_name",                       null: false
    t.string   "type",                             null: false
    t.boolean  "read_only",                        null: false
    t.string   "editor",                           null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "medical_device_id"
    t.boolean  "visible",           default: true
  end

  add_index "column_values", ["medical_device_id"], name: "index_column_values_on_medical_device_id", using: :btree
  add_index "column_values", ["visible"], name: "index_column_values_on_visible", using: :btree

  create_table "components", force: :cascade do |t|
    t.integer  "composable_id"
    t.string   "composable_type", limit: 255
    t.integer  "ingredient_id"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "components", ["composable_id", "composable_type"], name: "index_components_on_composable_id_and_composable_type", using: :btree
  add_index "components", ["ingredient_id"], name: "index_components_on_ingredient_id", using: :btree

  create_table "connections", force: :cascade do |t|
    t.boolean  "owner",      default: false, null: false
    t.string   "role",                       null: false
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "connections", ["group_id"], name: "index_connections_on_group_id", using: :btree
  add_index "connections", ["user_id"], name: "index_connections_on_user_id", using: :btree

  create_table "device_files", force: :cascade do |t|
    t.string   "filename"
    t.integer  "medical_device_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "upload_action"
  end

  add_index "device_files", ["medical_device_id"], name: "index_device_files_on_medical_device_id", using: :btree

  create_table "device_results", force: :cascade do |t|
    t.string   "filename"
    t.integer  "medical_device_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data",              null: false
    t.date     "date",              null: false
  end

  add_index "device_results", ["medical_device_id"], name: "index_device_results_on_medical_device_id", using: :btree

  create_table "devices", force: :cascade do |t|
    t.string   "token",      limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "devices", ["token"], name: "index_devices_on_token", unique: true, using: :btree
  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "eats", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.date     "eaten_on"
    t.decimal  "protein",                default: 0.0
    t.decimal  "carbs",                  default: 0.0
    t.decimal  "kcal",                   default: 0.0
    t.decimal  "fibre",                  default: 0.0
    t.decimal  "fat_s",                  default: 0.0
    t.decimal  "fat_u",                  default: 0.0
    t.decimal  "salt",                   default: 0.0
    t.decimal  "sugar",                  default: 0.0
    t.string   "lat",        limit: 255
    t.string   "lon",        limit: 255
  end

  add_index "eats", ["created_at"], name: "index_eats_on_created_at", order: {"created_at"=>:desc}, using: :btree
  add_index "eats", ["eaten_on"], name: "index_eats_on_eaten_on", using: :btree
  add_index "eats", ["user_id"], name: "index_eats_on_user_id", using: :btree

  create_table "eats_meals", id: false, force: :cascade do |t|
    t.integer "eat_id",  null: false
    t.integer "meal_id", null: false
  end

  add_index "eats_meals", ["eat_id"], name: "index_eats_meals_on_eat_id", using: :btree
  add_index "eats_meals", ["meal_id"], name: "index_eats_meals_on_meal_id", using: :btree

  create_table "eats_products", id: false, force: :cascade do |t|
    t.integer "eat_id",     null: false
    t.integer "product_id", null: false
  end

  add_index "eats_products", ["eat_id", "product_id"], name: "index_eats_products_on_eat_id_and_product_id", unique: true, using: :btree

  create_table "favourites", force: :cascade do |t|
    t.integer  "favouritable_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "favouritable_type", limit: 255
  end

  add_index "favourites", ["favouritable_id", "favouritable_type"], name: "index_favourites_on_favouritable_id_and_favouritable_type", using: :btree
  add_index "favourites", ["user_id", "favouritable_id", "favouritable_type"], name: "index_favourites_on_userid_and_favouritable_id_and_type", unique: true, using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",           null: false
    t.integer  "application_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "groups", ["application_id"], name: "index_groups_on_application_id", using: :btree

  create_table "historical_scores", force: :cascade do |t|
    t.integer  "history_id"
    t.string   "history_type", limit: 255
    t.date     "date",                     null: false
    t.integer  "nu"
    t.integer  "biometric"
    t.integer  "activity"
    t.integer  "nutrition"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "historical_scores", ["date"], name: "index_historical_scores_on_date", using: :btree
  add_index "historical_scores", ["history_id", "history_type"], name: "index_historical_scores_on_history_id_and_history_type", using: :btree

  create_table "images", force: :cascade do |t|
    t.integer  "imageable_id"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "imageable_type",     limit: 255
  end

  add_index "images", ["imageable_id", "imageable_type"], name: "index_images_on_imageable_id_and_imageable_type", using: :btree
  add_index "images", ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id", using: :btree

  create_table "ingredient_groups", force: :cascade do |t|
    t.string   "name",              limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon_file_name",    limit: 255
    t.string   "icon_content_type", limit: 255
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
  end

  create_table "ingredients", force: :cascade do |t|
    t.string   "name",                limit: 255,              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "protein"
    t.decimal  "carbs"
    t.decimal  "kcal"
    t.decimal  "fibre"
    t.decimal  "fat_s"
    t.decimal  "fat_u"
    t.decimal  "salt"
    t.decimal  "sugar"
    t.integer  "small_portion"
    t.integer  "medium_portion"
    t.integer  "large_portion"
    t.integer  "ingredient_group_id"
    t.hstore   "proximates",                      default: {}, null: false
    t.hstore   "minerals",                        default: {}, null: false
    t.hstore   "vitamins",                        default: {}, null: false
    t.hstore   "lipids",                          default: {}, null: false
    t.hstore   "other",                           default: {}, null: false
    t.integer  "ndb_no"
    t.hstore   "portions",                        default: {}, null: false
  end

  add_index "ingredients", ["ingredient_group_id"], name: "index_ingredients_on_ingredient_group_id", using: :btree

  create_table "invitations", force: :cascade do |t|
    t.string   "email",      limit: 255, null: false
    t.integer  "user_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["email"], name: "index_invitations_on_email", using: :btree
  add_index "invitations", ["team_id"], name: "index_invitations_on_team_id", using: :btree
  add_index "invitations", ["user_id"], name: "index_invitations_on_user_id", using: :btree

  create_table "meals", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       limit: 255,               null: false
    t.string   "type",       limit: 255
    t.string   "lat",        limit: 255
    t.string   "lon",        limit: 255
    t.decimal  "protein",                default: 0.0
    t.decimal  "carbs",                  default: 0.0
    t.decimal  "kcal",                   default: 0.0
    t.decimal  "fibre",                  default: 0.0
    t.decimal  "fat_s",                  default: 0.0
    t.decimal  "fat_u",                  default: 0.0
    t.decimal  "salt",                   default: 0.0
    t.decimal  "sugar",                  default: 0.0
  end

  add_index "meals", ["user_id"], name: "index_meals_on_user_id", using: :btree

  create_table "measurement_activities", force: :cascade do |t|
    t.integer  "user_id",                            null: false
    t.date     "date",                               null: false
    t.datetime "start_time",                         null: false
    t.datetime "end_time",                           null: false
    t.string   "type",       limit: 255,             null: false
    t.integer  "duration",               default: 0, null: false
    t.integer  "distance"
    t.integer  "steps"
    t.integer  "calories"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source",     limit: 255
    t.datetime "timestamp"
  end

  add_index "measurement_activities", ["date"], name: "index_measurement_activities_on_date", using: :btree
  add_index "measurement_activities", ["user_id"], name: "index_measurement_activities_on_user_id", using: :btree

  create_table "measurement_blood_oxygens", force: :cascade do |t|
    t.decimal  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "timestamp"
    t.date     "date",       null: false
    t.integer  "user_id",    null: false
  end

  add_index "measurement_blood_oxygens", ["date"], name: "index_measurement_blood_oxygens_on_date", using: :btree
  add_index "measurement_blood_oxygens", ["user_id"], name: "index_measurement_blood_oxygens_on_user_id", using: :btree

  create_table "measurement_blood_pressures", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.date     "date",                   null: false
    t.datetime "timestamp"
    t.string   "value",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measurement_blood_pressures", ["date"], name: "index_measurement_blood_pressures_on_date", using: :btree
  add_index "measurement_blood_pressures", ["user_id"], name: "index_measurement_blood_pressures_on_user_id", using: :btree

  create_table "measurement_bmis", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.date     "date",                   null: false
    t.datetime "timestamp",              null: false
    t.decimal  "value",                  null: false
    t.string   "unit",       limit: 255, null: false
    t.string   "source",     limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "prime"
  end

  add_index "measurement_bmis", ["date"], name: "index_measurement_bmis_on_date", using: :btree
  add_index "measurement_bmis", ["user_id"], name: "index_measurement_bmis_on_user_id", using: :btree

  create_table "measurement_bmrs", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.date     "date",                   null: false
    t.datetime "timestamp",              null: false
    t.decimal  "value"
    t.string   "unit",       limit: 255, null: false
    t.string   "source",     limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measurement_bmrs", ["date"], name: "index_measurement_bmrs_on_date", using: :btree
  add_index "measurement_bmrs", ["user_id"], name: "index_measurement_bmrs_on_user_id", using: :btree

  create_table "measurement_body_fats", force: :cascade do |t|
    t.decimal  "value"
    t.datetime "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date",       null: false
    t.integer  "user_id",    null: false
  end

  add_index "measurement_body_fats", ["date"], name: "index_measurement_body_fats_on_date", using: :btree
  add_index "measurement_body_fats", ["user_id"], name: "index_measurement_body_fats_on_user_id", using: :btree

  create_table "measurement_bpms", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.date     "date",       null: false
    t.datetime "timestamp"
    t.decimal  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measurement_bpms", ["date"], name: "index_measurement_bpms_on_date", using: :btree
  add_index "measurement_bpms", ["user_id"], name: "index_measurement_bpms_on_user_id", using: :btree

  create_table "measurement_heights", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.date     "date",                   null: false
    t.datetime "timestamp",              null: false
    t.decimal  "value",                  null: false
    t.string   "unit",       limit: 255, null: false
    t.string   "source",     limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measurement_heights", ["date"], name: "index_measurement_heights_on_date", using: :btree
  add_index "measurement_heights", ["user_id"], name: "index_measurement_heights_on_user_id", using: :btree

  create_table "measurement_steps", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.date     "date",       null: false
    t.datetime "timestamp"
    t.decimal  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measurement_steps", ["date"], name: "index_measurement_steps_on_date", using: :btree
  add_index "measurement_steps", ["user_id"], name: "index_measurement_steps_on_user_id", using: :btree

  create_table "measurement_weights", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "date"
    t.datetime "timestamp"
    t.decimal  "value"
    t.string   "unit",       limit: 255
    t.string   "source",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measurement_weights", ["date"], name: "index_measurement_weights_on_date", using: :btree
  add_index "measurement_weights", ["user_id"], name: "index_measurement_weights_on_user_id", using: :btree

  create_table "medical_devices", force: :cascade do |t|
    t.string   "name",                           null: false
    t.string   "token",                          null: false
    t.boolean  "enabled",        default: false
    t.integer  "application_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "medical_devices", ["application_id"], name: "index_medical_devices_on_application_id", using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer  "team_id",    null: false
    t.integer  "user_id",    null: false
    t.boolean  "owner"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["team_id"], name: "index_memberships_on_team_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.string   "message"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["recipient_id"], name: "index_notifications_on_recipient_id", using: :btree

  create_table "nutrition_breakdowns", force: :cascade do |t|
    t.integer  "user_id",                    null: false
    t.date     "date",                       null: false
    t.decimal  "kcal_g",       default: 0.0
    t.decimal  "kcal_perc",    default: 0.0
    t.decimal  "protein_g",    default: 0.0
    t.decimal  "protein_perc", default: 0.0
    t.decimal  "fibre_g",      default: 0.0
    t.decimal  "fibre_perc",   default: 0.0
    t.decimal  "carbs_g",      default: 0.0
    t.decimal  "carbs_perc",   default: 0.0
    t.decimal  "fat_u_g",      default: 0.0
    t.decimal  "fat_u_perc",   default: 0.0
    t.decimal  "fat_s_g",      default: 0.0
    t.decimal  "fat_s_perc",   default: 0.0
    t.decimal  "salt_g",       default: 0.0
    t.decimal  "salt_perc",    default: 0.0
    t.decimal  "sugar_g",      default: 0.0
    t.decimal  "sugar_perc",   default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nutrition_breakdowns", ["date"], name: "index_nutrition_breakdowns_on_date", using: :btree
  add_index "nutrition_breakdowns", ["user_id"], name: "index_nutrition_breakdowns_on_user_id", using: :btree

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id",             null: false
    t.integer  "application_id",                null: false
    t.string   "token",             limit: 255, null: false
    t.integer  "expires_in",                    null: false
    t.text     "redirect_uri",                  null: false
    t.datetime "created_at",                    null: false
    t.datetime "revoked_at"
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_grants", ["application_id"], name: "index_oauth_access_grants_on_application_id", using: :btree
  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             limit: 255, null: false
    t.string   "refresh_token",     limit: 255
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",                    null: false
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_tokens", ["application_id"], name: "index_oauth_access_tokens_on_application_id", using: :btree
  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                          limit: 255,                 null: false
    t.string   "uid",                           limit: 255,                 null: false
    t.string   "secret",                        limit: 255,                 null: false
    t.text     "redirect_uri",                                              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type",                    limit: 255
    t.text     "description"
    t.boolean  "enabled"
    t.string   "platform",                      limit: 255
    t.string   "icon_file_name",                limit: 255
    t.string   "icon_content_type",             limit: 255
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.string   "scopes",                        limit: 255, default: "",    null: false
    t.boolean  "user_limit",                                default: false
    t.boolean  "request_limit",                             default: false
    t.string   "apns_certificate_file_name"
    t.string   "apns_certificate_content_type"
    t.integer  "apns_certificate_file_size"
    t.datetime "apns_certificate_updated_at"
    t.string   "notification_bundleid"
    t.boolean  "notification_production",                   default: false
    t.string   "gcm_sender_id"
    t.string   "gcm_api_key"
    t.datetime "certificate_upload_date"
    t.string   "cloud_code_file_file_name"
    t.string   "cloud_code_file_content_type"
    t.integer  "cloud_code_file_file_size"
    t.datetime "cloud_code_file_updated_at"
    t.string   "mailgun_api_key"
    t.string   "mailgun_domain"
    t.string   "mailgun_from_address"
  end

  add_index "oauth_applications", ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type", using: :btree
  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "parse_apps", force: :cascade do |t|
    t.string   "app_id"
    t.string   "master_key"
    t.string   "client_key"
    t.integer  "application_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "port"
    t.string   "bucket"
  end

  add_index "parse_apps", ["application_id"], name: "index_parse_apps_on_application_id", using: :btree

  create_table "places", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "address",        limit: 255
    t.string   "lat",            limit: 255
    t.string   "lon",            limit: 255
    t.integer  "placeable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "placeable_type", limit: 255
  end

  add_index "places", ["placeable_id", "placeable_type"], name: "index_places_on_placeable_id_and_placeable_type", using: :btree
  add_index "places", ["placeable_id"], name: "index_places_on_placeable_id", using: :btree

  create_table "preferences", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.string   "value",      limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "preferences", ["user_id"], name: "index_preferences_on_user_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.string   "brand",               limit: 255
    t.string   "weight",              limit: 255
    t.string   "upc",                 limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                limit: 255
    t.string   "lat",                 limit: 255
    t.string   "lon",                 limit: 255
    t.string   "serving_size",        limit: 255
    t.decimal  "kcal",                            default: 0.0
    t.decimal  "protein",                         default: 0.0
    t.decimal  "fibre",                           default: 0.0
    t.decimal  "carbs",                           default: 0.0
    t.decimal  "fat_u",                           default: 0.0
    t.decimal  "fat_s",                           default: 0.0
    t.decimal  "salt",                            default: 0.0
    t.decimal  "sugar",                           default: 0.0
    t.boolean  "eat_ready"
    t.string   "factual_ingredients",             default: [],               array: true
    t.hstore   "other_nutrients",                 default: {},  null: false
  end

  add_index "products", ["upc"], name: "index_products_on_upc", unique: true, using: :btree

  create_table "profiles", force: :cascade do |t|
    t.string   "first_name",          limit: 255
    t.string   "last_name",           limit: 255
    t.string   "sex",                 limit: 255
    t.date     "birth_date"
    t.integer  "activity",                        default: 2,  null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "facebook_id",         limit: 255
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "time_zone",           limit: 255
    t.hstore   "data",                            default: {}, null: false
    t.string   "title"
    t.string   "about"
    t.string   "technologies",                    default: [],              array: true
    t.string   "location"
  end

  add_index "profiles", ["facebook_id"], name: "index_profiles_on_facebook_id", unique: true, using: :btree
  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "purchases", force: :cascade do |t|
    t.integer  "subscription_id"
    t.integer  "application_id"
    t.date     "expires_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price"
    t.string   "stripe_customer_token"
  end

  add_index "purchases", ["application_id"], name: "index_purchases_on_application_id", using: :btree
  add_index "purchases", ["subscription_id"], name: "index_purchases_on_subscription_id", using: :btree

  create_table "rights", force: :cascade do |t|
    t.string   "name",          null: false
    t.integer  "connection_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "rights", ["connection_id"], name: "index_rights_on_connection_id", using: :btree

  create_table "service_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", force: :cascade do |t|
    t.string   "name",                     limit: 255,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon_file_name",           limit: 255
    t.string   "icon_content_type",        limit: 255
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.text     "description"
    t.boolean  "needs_remote_credentials",             default: false
    t.boolean  "coming_soon",                          default: false
    t.integer  "service_category_id"
    t.string   "lib_name"
  end

  add_index "services", ["service_category_id"], name: "index_services_on_service_category_id", using: :btree

  create_table "stats", force: :cascade do |t|
    t.integer  "application_id"
    t.datetime "log_time"
    t.string   "resource_owner", limit: 255
    t.string   "request",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stats", ["application_id"], name: "index_stats_on_application_id", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.integer  "price"
    t.text     "description"
    t.integer  "user_limit"
    t.integer  "api_call_limit"
    t.integer  "storage"
    t.text     "support"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_notifications", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.string   "text",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "team_notifications", ["team_id"], name: "index_team_notifications_on_team_id", using: :btree
  add_index "team_notifications", ["user_id"], name: "index_team_notifications_on_user_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_goal"
    t.integer  "biometric_goal"
    t.integer  "nutrition_goal"
    t.integer  "application_id"
  end

  add_index "teams", ["application_id"], name: "index_teams_on_application_id", using: :btree

  create_table "tokens", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "scope",      limit: 255
  end

  add_index "tokens", ["user_id"], name: "index_tokens_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.citext   "email",                                    null: false
    t.string   "md5_password",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest", limit: 255
    t.datetime "confirmed_at"
    t.integer  "nu_score"
    t.integer  "biometric_score"
    t.integer  "activity_score"
    t.integer  "nutrition_score"
    t.string   "roles",           limit: 255, default: [],              array: true
    t.string   "name",            limit: 255
    t.string   "provider",        limit: 255
    t.string   "uid",             limit: 255
    t.hstore   "measurements",                default: {}, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true, using: :btree
  add_index "users", ["roles"], name: "index_users_on_roles", using: :gin

  add_foreign_key "components", "ingredients", name: "components_ingredient_id_fk", on_delete: :cascade
  add_foreign_key "connections", "groups"
  add_foreign_key "connections", "users"
  add_foreign_key "eats_products", "eats", name: "eats_products_eat_id_fk"
  add_foreign_key "eats_products", "products", name: "eats_products_product_id_fk"
  add_foreign_key "ingredients", "ingredient_groups", name: "ingredients_ingredient_group_id_fk", on_delete: :cascade
  add_foreign_key "invitations", "teams", name: "invitations_team_id_fk", on_delete: :cascade
  add_foreign_key "invitations", "users", name: "invitations_user_id_fk", on_delete: :cascade
  add_foreign_key "measurement_blood_oxygens", "users", on_delete: :cascade
  add_foreign_key "measurement_body_fats", "users", on_delete: :cascade
  add_foreign_key "memberships", "teams", name: "memberships_team_id_fk", on_delete: :cascade
  add_foreign_key "rights", "connections"
  add_foreign_key "team_notifications", "teams", name: "notifications_team_id_fk", on_delete: :cascade
  add_foreign_key "teams", "oauth_applications", column: "application_id", on_delete: :cascade
end
