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

ActiveRecord::Schema.define(version: 20150314191530) do

  create_table "dda_expenditures", force: true do |t|
    t.text     "title"
    t.decimal  "paid",       precision: 2, scale: 0
    t.string   "fund"
    t.text     "paid_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "losts", force: true do |t|
    t.integer  "item_number"
    t.integer  "bib_number"
    t.text     "title"
    t.string   "imprint"
    t.string   "isbn"
    t.string   "status"
    t.integer  "checkouts"
    t.string   "location"
    t.text     "note"
    t.string   "call_number"
    t.string   "volume"
    t.string   "barcode"
    t.date     "due_date"
    t.date     "last_checkout"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "oclc"
    t.string   "author"
  end

  create_table "orders", force: true do |t|
    t.string   "title"
    t.string   "author"
    t.string   "format"
    t.string   "publication_date"
    t.integer  "isbn"
    t.string   "publisher"
    t.integer  "oclc"
    t.string   "edition"
    t.string   "selector"
    t.string   "requestor"
    t.string   "location_code"
    t.string   "fund"
    t.integer  "cost"
    t.boolean  "added_edition"
    t.boolean  "added_copy"
    t.string   "added_copy_call_number"
    t.boolean  "rush_order"
    t.boolean  "rush_process"
    t.boolean  "notify"
    t.boolean  "reserve"
    t.string   "notification_contact"
    t.string   "relevant_url"
    t.string   "other_notes"
    t.string   "workflow_state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "vendor_code"
    t.string   "vendor_note"
    t.integer  "user_id"
    t.boolean  "not_yet_published"
    t.date     "not_yet_published_date"
  end

  create_table "sierra_indices", force: true do |t|
    t.string   "record_type"
    t.integer  "record_num"
    t.datetime "last_checked"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sierra_indices", ["last_checked"], name: "index_sierra_indices_on_last_checked"
  add_index "sierra_indices", ["record_num"], name: "index_sierra_indices_on_record_num"
  add_index "sierra_indices", ["record_type"], name: "index_sierra_indices_on_record_type"

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

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
