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

ActiveRecord::Schema.define(version: 20180411093017) do

  create_table "lopd_ambitos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "nombre", limit: 200, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "lopd_app_id", null: false
    t.index ["lopd_app_id"], name: "lopd_ambito_lopd_app_ref_ix"
    t.index ["nombre", "lopd_app_id"], name: "lopd_ambito_nombre_app_ix", unique: true
    t.index ["nombre"], name: "lopd_ambito_nombre_ix"
  end

  create_table "lopd_apps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "nombre", limit: 200, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "empresa", limit: 200
    t.index ["nombre"], name: "lopd_apps_nombre_ix", unique: true
  end

  create_table "lopd_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "usuario", limit: 200, null: false
    t.boolean "comercial", default: true, null: false
    t.boolean "grupo", default: true, null: false
    t.boolean "privacidad", default: true, null: false
    t.datetime "fecha_aceptacion", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "email", limit: 200
    t.string "nombre", limit: 200
    t.string "apellidos", limit: 200
    t.string "direccion", limit: 250
    t.string "telefono", limit: 200
    t.text "notas"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "lopd_ambito_id", null: false
    t.string "fax", limit: 200
    t.string "telefono2", limit: 200
    t.boolean "importacion", default: false, null: false
    t.index ["lopd_ambito_id"], name: "lopd_user_lopd_ambito_ref_ix"
  end

  add_foreign_key "lopd_ambitos", "lopd_apps"
  add_foreign_key "lopd_users", "lopd_ambitos"
end
