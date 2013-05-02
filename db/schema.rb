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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130423091501) do

  create_table "links", :force => true do |t|
    t.integer  "source_id"
    t.integer  "target_id"
    t.float    "strength"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "links", ["source_id", "target_id"], :name => "index_links_on_source_id_and_target_id", :unique => true

  create_table "nodes", :force => true do |t|
    t.integer  "followers_count"
    t.integer  "friends_count"
    t.integer  "statuses_count"
    t.date     "created_at",              :null => false
    t.text     "profile_image_url_https"
    t.text     "description"
    t.text     "location"
    t.text     "name"
    t.text     "screen_name"
    t.boolean  "protected"
    t.integer  "group_id"
    t.datetime "updated_at",              :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
