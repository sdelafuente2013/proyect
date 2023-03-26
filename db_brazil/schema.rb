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

ActiveRecord::Schema.define(version: 20180725111359) do

  create_table "ambito", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "nombre", limit: 30, null: false
    t.integer "orden", null: false
  end

  create_table "doctipo", primary_key: "tipoid", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "nombre", limit: 500, null: false
    t.boolean "check_permisos", default: true
  end

  create_table "grupo", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", null: false
    t.integer "tipoid", default: 0, null: false
    t.string "imagen", limit: 128
    t.boolean "pintanombre", default: false
    t.integer "authtype", default: 0
    t.integer "pais"
    t.index ["tipoid"], name: "grupo_tipoid_fk"
  end

  create_table "materia", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "nombre", null: false
    t.string "tema", null: false
    t.bigint "permisos_decimal", null: false
    t.string "permisos_binario", null: false
  end

  create_table "modulo", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "nombre", null: false
    t.integer "seccionweb"
  end

  create_table "per_presubscription", primary_key: "presubscriptionid", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "clave"
    t.datetime "creation_date"
    t.string "password", null: false
    t.string "perusuid", null: false
    t.bigint "usuarioid", null: false
    t.string "email_alta_tablet"
    t.string "clave_tablet"
    t.bigint "subscriptionid"
    t.string "nombre"
    t.string "apellidos"
    t.string "especialidad"
    t.string "telefono", limit: 16
    t.string "codigo_postal", limit: 8
    t.string "username"
    t.integer "pais"
  end

  create_table "per_subscription", primary_key: "subscriptionid", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.datetime "change_date"
    t.datetime "creation_date"
    t.string "password", limit: 32, null: false
    t.string "perusuid", null: false
    t.integer "type"
    t.bigint "usuarioid", null: false
    t.integer "subid", default: 0, null: false
    t.datetime "fecha_alta_tablet"
    t.string "email_alta_tablet"
    t.string "token"
    t.datetime "fecha_last_login_tablet"
    t.boolean "acceso_tablet", default: false
    t.datetime "mydocs_change_date"
    t.datetime "mysearches_change_date"
    t.binary "news", limit: 1, default: "1"
    t.string "nombre"
    t.string "apellidos"
    t.string "especialidad"
    t.string "telefono", limit: 16
    t.string "codigo_postal", limit: 8
    t.string "username"
    t.datetime "fecha_last_login"
    t.bigint "oldsubscriptionid"
    t.integer "pais"
    t.binary "countrynews", limit: 1, default: "1"
    t.index ["subid"], name: "per_sub_id"
  end

  create_table "producto", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", null: false
  end

  create_table "subsystem", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "name", null: false
  end

  create_table "tipo_acceso", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "descripcion", null: false
  end

  create_table "tipo_acceso_tablet", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", null: false
  end

  create_table "tipo_usuario_grupo", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", null: false
  end

  create_table "userips", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "usuarioid", null: false
    t.string "ipfrom", null: false
    t.string "ipto", null: false
    t.index ["usuarioid"], name: "userips_usuarioid_fk"
  end

  create_table "usuario", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "username", null: false
    t.string "password"
    t.integer "maxconexiones"
    t.string "permisos"
    t.string "email"
    t.string "comentario"
    t.datetime "fecharevision"
    t.integer "grupoid"
    t.integer "subid", default: 0, null: false
    t.string "referer"
    t.string "imagen"
    t.integer "tipousuariogrupoid", default: 0, null: false
    t.binary "iscolectivo", limit: 1, default: "0", null: false
    t.datetime "datelimit"
    t.datetime "fechaalta"
    t.string "nombre"
    t.string "apellidos"
    t.string "url_origen"
    t.integer "tipoaccesoid"
    t.binary "isdemo", limit: 1, default: "0", null: false
    t.integer "tipoaccesotabletid", default: 1, null: false
    t.string "dominios"
    t.integer "pais"
    t.string "nif", limit: 15
    t.index ["grupoid"], name: "usuario_grupoid_fk"
    t.index ["subid"], name: "usuario_subid_fk"
    t.index ["tipoaccesoid"], name: "usuario_tipoaccesoid_fk"
    t.index ["tipoaccesotabletid"], name: "usuario_tipoacceso_tablet_fk"
    t.index ["tipousuariogrupoid"], name: "usuario_tipousuariogrupoid_fk"
    t.index ["username"], name: "username_UNIQUE", unique: true
  end

  create_table "usuario_cloudlibrary", primary_key: ["moduloid", "usuarioid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "usuarioid", null: false
    t.string "cloud_user", default: "", null: false
    t.string "cloud_password"
    t.bigint "moduloid", null: false
    t.index ["usuarioid"], name: "usuario_cloudlibrary_usuarioid_fk"
  end

  create_table "usuario_stats", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "usuario_id", null: false
    t.datetime "fecha"
    t.integer "sesiones", null: false
    t.integer "documentos", null: false
    t.index ["fecha"], name: "idx_fecha"
    t.index ["usuario_id", "fecha"], name: "idx_usuarioid_fecha"
  end

end
