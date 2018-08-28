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


ActiveRecord::Schema.define(version: 20180312073648) do


  create_table "adwords", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.bigint "campaign_id"
    t.string "text"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 2
    t.index ["campaign_id"], name: "index_adwords_on_campaign_id"
  end

  create_table "areas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "name"
    t.bigint "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_areas_on_city_id"
  end

  create_table "campaigns", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.bigint "property_id"
    t.datetime "started_at"
    t.datetime "expired_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_campaigns_on_property_id"
  end

  create_table "chatroom_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.bigint "chatroom_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chatroom_id"], name: "index_chatroom_users_on_chatroom_id"
    t.index ["user_id"], name: "index_chatroom_users_on_user_id"
  end

  create_table "chatrooms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "intentions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "message_attachments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.bigint "message_log_id"
    t.string "attachment_type"
    t.text "url", limit: 16777215
    t.decimal "lat", precision: 20, scale: 15
    t.decimal "long", precision: 20, scale: 15
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_log_id"], name: "index_message_attachments_on_message_log_id"
  end

  create_table "message_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.bigint "user_id"
    t.string "intention_name"
    t.text "text", limit: 16777215
    t.string "message_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "seq"
    t.datetime "sent_at"
    t.string "mid"
    t.bigint "intention_id"
    t.text "luis"
    t.text "echo_attachments"
    t.string "payload_name"
    t.integer "payload_id"
    t.text "tthouse_api_nlp"
    t.decimal "intention_score", precision: 15, scale: 10
    t.text "payload_param"
    t.bigint "session_id"
    t.string "platform", default: "facebook"
    t.string "source"

    t.index ["intention_id"], name: "index_message_logs_on_intention_id"
    t.index ["session_id"], name: "index_message_logs_on_session_id"
    t.index ["user_id"], name: "index_message_logs_on_user_id"
  end

  create_table "payloads", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "properties", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "address"
    t.string "title"
    t.string "property_type"
    t.string "status"
    t.string "city"
    t.string "area"
    t.float "price", limit: 24
    t.decimal "lat", precision: 20, scale: 15
    t.decimal "long", precision: 20, scale: 15
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sid"
    t.string "company"
    t.float "sec_price", limit: 24
    t.text "images_path", limit: 16777215
    t.text "modify_time", limit: 16777215
    t.integer "zip"
    t.string "building_type"
    t.float "size_min", limit: 24
    t.integer "garage"
    t.float "garage_price", limit: 24
    t.string "state"
    t.string "road"
    t.float "price_min", limit: 24
    t.float "price_max", limit: 24
    t.string "sales_status"
    t.string "floor_status"
    t.string "address_detail"
    t.float "sec_max", limit: 24, default: 0.0
    t.float "sec_min", limit: 24, default: 0.0
    t.boolean "available", default: true
    t.string "room"
    t.string "price_range"
    t.string "public_rate"
    t.integer "click_count", default: 0
    t.string "url"
    t.integer "room_min"
    t.integer "room_max"
    t.float "public_ratio_min", limit: 24
    t.float "public_ratio_max", limit: 24
    t.integer "household_number"
  end

  create_table "replies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.text "text", limit: 16777215
    t.string "reply_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "trigger_id"
    t.string "trigger_type"
  end

  create_table "roads", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "name"
    t.bigint "area_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_roads_on_area_id"
  end

  create_table "session_slots", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.bigint "session_id"
    t.bigint "slot_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "required"
    t.integer "priority"
    t.string "name"
    t.string "slot_type", default: "text"
    t.boolean "is_hint", default: false
    t.string "prompt_options"
    t.index ["session_id"], name: "index_session_slots_on_session_id"
    t.index ["slot_id"], name: "index_session_slots_on_slot_id"
  end

  create_table "sessions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.bigint "user_id"
    t.string "state"
    t.datetime "finished_at"
    t.datetime "last_messaged_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "trigger_id"
    t.string "trigger_type"
    t.datetime "expired_at"
    t.datetime "conversation_started_at"
    t.integer "conversation_with_user_id"
    t.string "status", default: "bot"
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "slot_prompts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.bigint "slot_id"
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category", default: "required"
    t.index ["slot_id"], name: "index_slot_prompts_on_slot_id"
  end

  create_table "slots", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "trigger_id"
    t.string "trigger_type"
    t.boolean "required"
    t.integer "priority"
    t.string "slot_type", default: "text"
    t.boolean "is_hint", default: false
  end

  create_table "synonyms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "name"
    t.bigint "term_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["term_id"], name: "index_synonyms_on_term_id"
  end

  create_table "term_relations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "relation_type"
    t.bigint "term_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["term_id"], name: "index_term_relations_on_term_id"
  end

  create_table "terms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "name"
    t.string "term_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "sender_id"
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.string "profile_pic"
    t.string "locale"
    t.datetime "last_active_at"
    t.string "bot_status", default: "welcome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fanpage_id"
    t.decimal "long", precision: 20, scale: 15
    t.decimal "lat", precision: 20, scale: 15
    t.string "address"
    t.string "role", default: "user"
    t.string "provider"
    t.string "fb_uid"
    t.datetime "handed_over_at"
    t.string "current_status"
    t.string "line_uid"
    t.string "source", default: "facebook"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["sender_id"], name: "index_users_on_sender_id", unique: true
  end

  add_foreign_key "adwords", "campaigns"
  add_foreign_key "areas", "cities"
  add_foreign_key "campaigns", "properties"
  add_foreign_key "chatroom_users", "chatrooms"
  add_foreign_key "chatroom_users", "users"
  add_foreign_key "message_attachments", "message_logs"
  add_foreign_key "message_logs", "users"
  add_foreign_key "roads", "areas"
  add_foreign_key "session_slots", "sessions"
  add_foreign_key "session_slots", "slots"
  add_foreign_key "sessions", "users"
  add_foreign_key "slot_prompts", "slots"
  add_foreign_key "synonyms", "terms"
  add_foreign_key "term_relations", "terms"
end
