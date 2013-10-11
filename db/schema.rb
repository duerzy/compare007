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

ActiveRecord::Schema.define(version: 20131009095937) do

  create_table "bill007s", force: true do |t|
    t.string   "recordTime"
    t.integer  "refundAmount"
    t.integer  "extraAmount"
    t.integer  "billAmount"
    t.integer  "balance"
    t.string   "TraceNumber007"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bill007s", ["TraceNumber007", "refundAmount", "extraAmount", "billAmount"], name: "TraceNumber007", unique: true, using: :btree

  create_table "compares", force: true do |t|
    t.string   "orderFile"
    t.string   "record007File"
    t.datetime "submitTime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "daily_settles", force: true do |t|
    t.string   "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "amount"
    t.string   "confirm"
  end

  create_table "orders", force: true do |t|
    t.string   "orderId"
    t.string   "busCode"
    t.string   "busName"
    t.string   "tradeTime"
    t.string   "settleDate"
    t.integer  "amount"
    t.string   "tranStatus"
    t.string   "payMethod"
    t.string   "settleNumber"
    t.string   "mno"
    t.string   "bill007Id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dailySettle_id"
    t.string   "isError"
    t.integer  "cost"
    t.string   "isManual"
    t.string   "phoneNumber"
    t.string   "manualDate"
    t.string   "isManualRefund"
    t.string   "errored"
    t.string   "refunded"
  end

  add_index "orders", ["bill007Id"], name: "bill007Id", using: :btree
  add_index "orders", ["dailySettle_id"], name: "index_orders_on_dailySettle_id", using: :btree
  add_index "orders", ["orderId", "tranStatus"], name: "orderId_status_uni", unique: true, using: :btree

  create_table "record007s", force: true do |t|
    t.string   "recordTime"
    t.string   "traceNumber007"
    t.string   "bill007Id"
    t.string   "namedAmount"
    t.string   "trueAmount"
    t.string   "phoneNumber"
    t.string   "status"
    t.string   "comment"
    t.integer  "settleAmount"
    t.integer  "commission"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "record007s", ["traceNumber007", "bill007Id"], name: "trance_billId_uni", unique: true, using: :btree

  create_table "v_bill007_records", id: false, force: true do |t|
    t.string  "billTime"
    t.string  "recordTime"
    t.integer "refundAmount"
    t.integer "extraAmount"
    t.integer "billAmount"
    t.integer "balance"
    t.string  "TranceNumber007"
    t.string  "bill007Id"
    t.string  "namedAmount"
    t.string  "phoneNumber"
    t.integer "settleAmount"
  end

  create_table "v_record007_bills", id: false, force: true do |t|
    t.string  "billTime"
    t.string  "recordTime"
    t.integer "refundAmount"
    t.integer "extraAmount"
    t.integer "billAmount"
    t.integer "balance"
    t.string  "TranceNumber007"
    t.string  "bill007Id"
    t.string  "trueAmount"
    t.string  "phoneNumber"
    t.integer "settleAmount"
    t.string  "status"
    t.string  "comment"
  end

end
