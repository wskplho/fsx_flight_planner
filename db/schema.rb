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

ActiveRecord::Schema.define(:version => 20110812194406) do

  create_table "airports", :force => true do |t|
    t.integer  "id_country"
    t.string   "name"
    t.string   "code"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "elevation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "airports", ["id_country"], :name => "index_airports_on_id_country"

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "runways", :force => true do |t|
    t.integer  "id_airport"
    t.integer  "length"
    t.integer  "elevation"
    t.boolean  "hard"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "runways", ["id_airport"], :name => "index_runways_on_id_airport"

end
