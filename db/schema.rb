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

ActiveRecord::Schema.define(version: 20160610180448) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dda_expenditures", force: true do |t|
    t.text     "title"
    t.decimal  "paid"
    t.string   "fund"
    t.date     "paid_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "losts", force: true do |t|
    t.integer  "item_number"
    t.integer  "bib_number"
    t.text     "title"
    t.text     "imprint"
    t.text     "isbn"
    t.text     "status"
    t.integer  "checkouts"
    t.text     "location"
    t.text     "note"
    t.text     "call_number"
    t.text     "volume"
    t.text     "barcode"
    t.date     "due_date"
    t.date     "last_checkout"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "oclc"
    t.text     "author"
    t.boolean  "reviewed"
  end

  create_table "orders", force: true do |t|
    t.text     "title"
    t.text     "author"
    t.text     "format"
    t.text     "publication_date"
    t.text     "isbn"
    t.text     "publisher"
    t.integer  "oclc",                   limit: 8
    t.text     "edition"
    t.text     "selector"
    t.text     "requestor"
    t.text     "location_code"
    t.text     "fund"
    t.integer  "cost"
    t.boolean  "added_edition"
    t.boolean  "added_copy"
    t.text     "added_copy_call_number"
    t.boolean  "rush_order"
    t.boolean  "notify"
    t.boolean  "reserve"
    t.text     "notification_contact"
    t.text     "relevant_url"
    t.text     "other_notes"
    t.text     "workflow_state"
    t.text     "vendor_address"
    t.boolean  "credit_card_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "vendor_code"
    t.string   "vendor_note"
    t.integer  "user_id"
    t.boolean  "not_yet_published"
    t.date     "not_yet_published_date"
    t.text     "internal_note"
    t.text     "processing_note"
    t.string   "currency"
    t.text     "series"
    t.text     "language"
  end

  create_table "problems", force: true do |t|
    t.text     "title"
    t.integer  "record_num"
    t.string   "record_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "type"
  end

  create_table "sierra_indices", force: true do |t|
    t.string   "record_type"
    t.integer  "record_num"
    t.datetime "last_checked"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sierra_indices", ["last_checked"], name: "index_sierra_indices_on_last_checked", using: :btree
  add_index "sierra_indices", ["record_num"], name: "index_sierra_indices_on_record_num", using: :btree
  add_index "sierra_indices", ["record_type"], name: "index_sierra_indices_on_record_type", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "location"
    t.boolean  "lmlo_receives_report"
    t.integer  "selector_id"
    t.string   "type"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
