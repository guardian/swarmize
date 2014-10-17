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

ActiveRecord::Schema.define(version: 20141017131200) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_permissions", force: true do |t|
    t.integer  "swarm_id"
    t.integer  "user_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_owner",   default: false
    t.integer  "creator_id"
  end

  add_index "access_permissions", ["email"], name: "index_access_permissions_on_email", using: :btree

  create_table "graphs", force: true do |t|
    t.string   "title"
    t.string   "graph_type"
    t.string   "field"
    t.text     "options"
    t.integer  "swarm_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "swarm_fields", force: true do |t|
    t.integer  "field_index"
    t.string   "field_type"
    t.string   "field_name"
    t.string   "field_code"
    t.text     "hint"
    t.string   "sample_value"
    t.boolean  "compulsory",      default: false
    t.text     "possible_values"
    t.integer  "minimum"
    t.integer  "maximum"
    t.integer  "swarm_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "other",           default: false
  end

  create_table "swarms", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "opens_at"
    t.datetime "closes_at"
    t.integer  "cloned_from"
    t.string   "token",               limit: 8
    t.datetime "deleted_at"
    t.boolean  "display_title",                 default: true
    t.boolean  "display_description",           default: true
  end

  add_index "swarms", ["deleted_at"], name: "index_swarms_on_deleted_at", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_fake",    default: false
    t.boolean  "is_admin",   default: false
  end

end
