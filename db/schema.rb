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

ActiveRecord::Schema.define(version: 20160825202809) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agencies", force: :cascade do |t|
    t.string   "name",                              null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "phone",             default: "-"
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "address"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "website_url"
    t.integer  "num_employees"
    t.boolean  "golden_pitch",      default: false
    t.boolean  "silver_pitch",      default: false
    t.boolean  "medium_risk_pitch", default: false
    t.boolean  "high_risk_pitch",   default: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "agency_skills", force: :cascade do |t|
    t.integer  "agency_id"
    t.integer  "skill_id"
    t.integer  "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_agency_skills_on_agency_id", using: :btree
    t.index ["skill_id"], name: "index_agency_skills_on_skill_id", using: :btree
  end

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "new_user_requests", force: :cascade do |t|
    t.string   "email",                          null: false
    t.string   "agency",     default: "",        null: false
    t.string   "user_type",  default: "agencia", null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "skill_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skills", force: :cascade do |t|
    t.string   "name"
    t.integer  "skill_category_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["skill_category_id"], name: "index_skills_on_skill_category_id", using: :btree
  end

  create_table "success_cases", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "case_image_file_name"
    t.string   "case_image_content_type"
    t.integer  "case_image_file_size"
    t.datetime "case_image_updated_at"
    t.integer  "agency_id"
    t.index ["agency_id"], name: "index_success_cases_on_agency_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "auth_token",             default: ""
    t.integer  "role",                   default: 2,     null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "is_member_amap",         default: false
    t.integer  "agency_id"
    t.index ["agency_id"], name: "index_users_on_agency_id", using: :btree
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "agency_skills", "agencies"
  add_foreign_key "agency_skills", "skills"
  add_foreign_key "skills", "skill_categories"
  add_foreign_key "success_cases", "agencies"
  add_foreign_key "users", "agencies"
end
