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

ActiveRecord::Schema.define(version: 201903072010101) do

  create_table "alert_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "app_id", null: false
    t.string "email", null: false
    t.datetime "created_at"
    t.index ["app_id", "email"], name: "index_alert_users_on_app_id_and_email", unique: true
  end

  create_table "alerts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "app_id", null: false
    t.bigint "document_id", null: false
    t.datetime "alert_date"
    t.bigint "alertable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "alertable_type", default: "Mex::AlertUser"
    t.string "document_tolgeo", default: "mex", null: false
    t.index ["alertable_id", "alertable_type"], name: "index_alerts_on_alertable_id_and_alertable_type"
    t.index ["app_id", "document_id", "document_tolgeo", "alertable_id", "alertable_type"], name: "index_alerts_app_id_document_id_alertable_id_alertable_type", unique: true
  end

  create_table "alta_gratuita", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.datetime "fechaalta"
    t.datetime "fechasolicitud"
    t.string "nombre", limit: 128
    t.string "email", limit: 256, null: false
    t.string "cp", limit: 8
    t.string "tipousuarioid", limit: 128
    t.string "telefono", limit: 16
    t.string "apellidos", limit: 128
    t.integer "subid", default: -1, null: false
  end

  create_table "alta_novedades_gratuitas", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.datetime "fechaalta"
    t.datetime "fechasolicitud"
    t.string "nombre", limit: 128
    t.string "apellidos", limit: 128
    t.string "email", limit: 256, null: false
    t.string "cp", limit: 8
    t.string "telefono", limit: 16
    t.integer "subid", null: false
  end

  create_table "ambito", primary_key: "ambitoid", id: :integer, default: 0, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "nombre", limit: 30, null: false
    t.integer "orden", null: false
  end

  create_table "banner", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "subid", null: false
    t.integer "orden", null: false
    t.string "file_name", null: false
    t.integer "gmid"
    t.string "url"
    t.index ["subid"], name: "banner_subid_fk"
  end

  create_table "banner_boletin_novedades", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "imagen", null: false
    t.string "titulo"
    t.string "texto"
    t.integer "orden", null: false
    t.string "isbn", limit: 16
    t.string "url", limit: 1024
    t.string "numtol", limit: 24
    t.integer "subid", default: 0, null: false
    t.index ["imagen"], name: "banner_boletin_novedades_imagen_fk"
  end

  create_table "boletin", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.boolean "activo"
    t.datetime "fecha", null: false
    t.string "nombre", null: false
    t.bigint "pais_id"
    t.integer "subid", null: false
    t.index ["subid"], name: "subid", unique: true
  end

  create_table "catalogo_banner", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "filename", null: false
    t.string "titulo", null: false
    t.string "sizeimg", limit: 16, null: false
  end

  create_table "contactos_comerciales", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "nombre"
    t.string "apellidos"
    t.string "email", null: false
    t.string "telefono", limit: 16
    t.string "codigo_postal", limit: 8
    t.string "poblacion", limit: 128
    t.datetime "fecha_alta", null: false
    t.integer "subid", default: 0, null: false
    t.string "origen", limit: 128
    t.bigint "id_usuario"
    t.boolean "iscolectivo", default: false, null: false
    t.boolean "publicidad", default: false, null: false
    t.index ["subid"], name: "contactos_comerciales_subid_fk"
  end

  create_table "deleted_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "username", null: false
    t.string "password", null: false
    t.integer "userid", null: false
    t.integer "subid", null: false
    t.text "comentario"
    t.datetime "fechaalta", null: false
    t.datetime "fechaborrado", null: false
    t.integer "backoffice_user_id", null: false
    t.string "backoffice_user_name", null: false
    t.index ["fechaborrado"], name: "index_deleted_users_on_fechaborrado"
  end

  create_table "despbautor", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "autor", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "despcemisor", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "emisor", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "despctipo", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "tipo", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "despdautor", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "autor", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "despdrevista", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "nombre", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "despeditorial", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "codigo", limit: 25
    t.string "nombre", limit: 500, null: false
  end

  create_table "despfemisor", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "emisor", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "despgboletin", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "boletin", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "desppaislatam", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "codigo", null: false
    t.string "codigo_iso", limit: 3, null: false
    t.string "nombre", limit: 256, null: false
    t.integer "subid", null: false
    t.string "codigo_iso_2digits"
  end

  create_table "despsboletin", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "boletin", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "despscaso", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "caso", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "despsentidadgeografica", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "entidadgeografica", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "despsepoca", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "epoca", limit: 500, null: false
    t.integer "orden", null: false
    t.bigint "padre_id"
    t.binary "asignable", limit: 1, null: false
  end

  create_table "despsinstancia", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "instancia", limit: 500, null: false
    t.integer "orden", null: false
    t.bigint "padre_id"
    t.binary "asignable", limit: 1, null: false
  end

  create_table "despsjurisdiccion", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "jurisdiccion", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "despsmotivacion", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "motivacion", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "despsorganoorigen", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "organoorigen", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "despsorigen", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "origen", limit: 500, null: false
    t.integer "orden", null: false
    t.bigint "padre_id"
    t.integer "tipo"
  end

  create_table "despspais", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "pais", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "despsponente", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "orden", null: false
    t.string "ponente", null: false
  end

  create_table "despstipoasunto", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "tipoasunto", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "despstiporesolucion", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "tiporesolucion", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "despstiposentencia", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "tiposentencia", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "despstiposentencia_interamericana", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "tiposentencia_interamericana", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "despsvigencia", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "vigencia", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "desptambitogeografico", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "ambitogeografico", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "desptboletin", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "boletin", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "desptentidad", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "entidad", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "desptipodoctrina", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "tipo", limit: 500, null: false
    t.integer "orden", null: false
    t.boolean "es_revista"
  end

  create_table "desptipotextolegal", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "tipo", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "desptlocalidad", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "localidad", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "desptordenamiento", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "ordenamiento", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "desptvigencia", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "vigencia", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "docindice", primary_key: "catid", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "parentid"
    t.string "descripcion", limit: 1000, null: false
    t.boolean "hoja", default: false, null: false
    t.bigint "orden"
    t.integer "profundidad"
    t.boolean "no_despliega_en_web", default: false
    t.boolean "contiene_redacciones", default: false
    t.boolean "temporalmente_nosegestionan", default: false, null: false
    t.integer "ambito_id"
    t.index ["ambito_id"], name: "docindice_ambito_id_fk"
    t.index ["parentid"], name: "docindice_parent_id_ix"
  end

  create_table "docindice_antecesores", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "catid"
    t.bigint "parentid"
    t.integer "profundidad", null: false
    t.index ["catid", "parentid", "profundidad"], name: "docindice_antecesores_unique_ix", unique: true
  end

  create_table "docindice_idiomas", primary_key: ["catid", "idiomaid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "catid", null: false
    t.integer "idiomaid", null: false
    t.string "descripcion", limit: 1000, null: false
  end

  create_table "docindice_idiomas_temporalmente_nosegestionan", primary_key: ["catid", "idiomaid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "catid", null: false
    t.integer "idiomaid", null: false
    t.string "descripcion", limit: 1000, null: false
  end

  create_table "docindice_materia", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "catid"
    t.integer "materiaid"
    t.index ["catid"], name: "docindice_materia_catid_fk"
    t.index ["materiaid"], name: "docindice_materia_materiaid_fk"
  end

  create_table "docindice_search", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "catid", null: false
    t.bigint "rootid"
    t.text "descripcion", null: false
    t.integer "ambito"
    t.integer "materiaid"
    t.boolean "hoja", default: false, null: false
    t.boolean "derogada", default: false
    t.index ["descripcion"], name: "descripcion", type: :fulltext
  end

  create_table "docindice_settings", primary_key: "catid", id: :bigint, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.boolean "voz", default: false, null: false
    t.integer "nivel_voces_id"
    t.datetime "fecha"
    t.boolean "derogada", default: false
    t.boolean "homelink", default: false, null: false
    t.string "keywords"
    t.boolean "nube_voces", default: false, null: false
    t.bigint "documento_principal_id"
    t.index ["voz"], name: "docindice_settings_voz_ix"
  end

  create_table "docindice_settings_temporalmente_nosegestionan", primary_key: "catid", id: :bigint, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.boolean "voz", default: false, null: false
    t.integer "nivel_voces_id"
    t.datetime "fecha"
    t.boolean "derogada", default: false
    t.boolean "homelink", default: false, null: false
    t.string "keywords"
    t.boolean "nube_voces", default: false, null: false
    t.bigint "documento_principal_id"
  end

  create_table "docindice_temporalmente_nosegestionan", primary_key: "catid", id: :bigint, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "parentid"
    t.string "descripcion", limit: 1000, null: false
    t.binary "hoja", limit: 1, null: false
    t.bigint "orden"
    t.integer "profundidad"
    t.boolean "no_despliega_en_web", default: false
    t.boolean "contiene_redacciones", default: false
  end

  create_table "doctipo", primary_key: "tipoid", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "nombre", limit: 500, null: false
  end

  create_table "doctrina_autor", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "libro_doctrina_id", null: false
    t.bigint "autor_id", null: false
    t.integer "autores_idx", null: false
    t.index ["autor_id"], name: "doctrina_autor_autor_id_fk"
    t.index ["libro_doctrina_id", "autor_id"], name: "doctrina_autor_unique_ix", unique: true
  end

  create_table "documento", primary_key: "docid", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "backend_id", null: false
    t.integer "tipoid", null: false
    t.string "titulodoc", limit: 500, null: false
    t.datetime "fecharevision", default: "2013-03-03 00:00:00", null: false
  end

  create_table "documento_ambito", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "documento_id", null: false
    t.integer "ambito_id", null: false
    t.index ["ambito_id"], name: "documento_ambito_ambitoid_fk"
    t.index ["documento_id"], name: "documento_ambito_docid_fk"
  end

  create_table "documento_enlaces", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "docid", null: false
    t.bigint "docid_enlace", null: false
    t.index ["docid"], name: "documento_enlaces_docid_ix"
    t.index ["docid_enlace"], name: "documento_enlaces_docid_enlace_ix"
  end

  create_table "documento_referencia", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "docid", null: false
    t.bigint "docid_enlace", null: false
    t.index ["docid"], name: "documento_referencia_docid_ix"
    t.index ["docid_enlace"], name: "documento_referencia_docid_enlace_ix"
  end

  create_table "enlaceproducto", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "tipo", null: false
    t.string "descripcion"
    t.string "titulo", null: false
    t.string "link", null: false
    t.integer "athome"
    t.integer "orden", null: false
  end

  create_table "error_acceso", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "tipo_error_acceso_id", null: false
    t.bigint "usuarioid"
    t.string "username"
    t.string "descripcion", null: false
    t.datetime "created_at", null: false
    t.string "tipo_peticion"
    t.index ["tipo_error_acceso_id"], name: "error_acceso_tipo_ix"
    t.index ["username"], name: "error_acceso_username_ix"
    t.index ["usuarioid"], name: "error_acceso_usuarioid_ix"
  end

  create_table "gm_materia", primary_key: ["gmid", "materiaid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "gmid", null: false
    t.integer "materiaid", null: false
    t.integer "orden", null: false
    t.index ["materiaid"], name: "gm_materia_materiaid_fk"
  end

  create_table "gm_servicio", primary_key: ["gmid", "servicioid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "gmid", null: false
    t.integer "servicioid", null: false
    t.integer "orden"
    t.index ["servicioid"], name: "servicioid"
  end

  create_table "gm_usuario", primary_key: ["usuarioid", "gmid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "usuarioid", null: false
    t.integer "gmid", null: false
    t.index ["gmid"], name: "gm_usuario_grupomateriaid_fk"
  end

  create_table "grupo", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", null: false
    t.integer "tipoid", default: 0, null: false
    t.string "imagen", limit: 128
    t.boolean "pintanombre", default: false
    t.integer "authtype", default: 0
    t.integer "pais"
    t.boolean "show_demo", default: false, null: false
    t.boolean "show_alta_personalizacion", default: false, null: false
    t.index ["tipoid"], name: "grupo_tipoid_fk"
  end

  create_table "grupo_materia", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", null: false
  end

  create_table "grupo_novedades_notarios", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", limit: 50, null: false
    t.integer "orden", null: false
  end

  create_table "grupo_servicio", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "name", null: false
    t.integer "subid", null: false
    t.integer "order", null: false
    t.index ["subid"], name: "grupo_servicio_subid_fk"
  end

  create_table "idioma", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", limit: 100, null: false
    t.integer "orden"
  end

  create_table "indice_composicion_asignaciones", primary_key: ["compuesto", "componente"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "compuesto", null: false
    t.bigint "componente", null: false
  end

  create_table "indice_recomendados", primary_key: ["catid", "recomendado"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "catid", null: false
    t.bigint "recomendado", null: false
  end

  create_table "isbn_portada", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "isbn", limit: 500, null: false
  end

  create_table "li_continente", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", limit: 100, null: false
    t.integer "orden", null: false
    t.string "imagen", limit: 100
  end

  create_table "li_enlace", id: :bigint, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "pais_id", null: false
    t.string "seccion", limit: 100
    t.string "norma", limit: 1024
    t.string "texto", limit: 1024
    t.string "url", limit: 1024
    t.integer "orden"
    t.index ["pais_id"], name: "pais_id"
  end

  create_table "li_pais", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", limit: 100, null: false
    t.integer "orden", null: false
    t.integer "continente_id", null: false
    t.index ["continente_id"], name: "continente_id"
  end

  create_table "libro_doctrina", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "titulo", limit: 2000, null: false
    t.string "isbn", limit: 25
    t.string "fecha", limit: 25
  end

  create_table "materia", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "nombre", null: false
    t.string "tema", null: false
    t.bigint "permisos_decimal", null: false
    t.string "permisos_binario", null: false
    t.string "imagen"
    t.string "imagen_small"
  end

  create_table "materia_subsystem", primary_key: ["materiaid", "subid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "materiaid", null: false
    t.integer "subid", null: false
    t.integer "orden", null: false
    t.index ["subid"], name: "materia_subsystem_subid_fk"
  end

  create_table "migrations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "last_migration", limit: 256, null: false
    t.timestamp "date_migration", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "mobile_app_version", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "appname", limit: 25, null: false
    t.string "osname", limit: 25, null: false
    t.string "version", limit: 25, null: false
  end

  create_table "modulo", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "nombre", null: false
    t.integer "seccionweb"
    t.string "key"
  end

  create_table "modulo_premium_subsystem", primary_key: ["moduloid", "subid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "moduloid", null: false
    t.integer "subid", null: false
    t.index ["subid"], name: "modulo_premium_subsystem_subid_fk"
  end

  create_table "modulo_subsystem", primary_key: ["moduloid", "subid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "moduloid", null: false
    t.integer "subid", null: false
    t.integer "orden"
    t.index ["subid"], name: "modulo_subsystem_subid_fk"
  end

  create_table "nivel_voces", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", null: false
    t.integer "orden", null: false
  end

  create_table "novedad", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "docid", null: false
    t.datetime "dateto"
    t.datetime "datefrom"
    t.boolean "athome", default: false, null: false
    t.string "autor", limit: 128
    t.string "comentario", limit: 1024
    t.boolean "destacado", default: false, null: false
    t.datetime "fecha_creacion"
    t.boolean "to_latam", default: false, null: false
    t.bigint "editorialid"
    t.integer "subid", null: false
    t.integer "materiaid"
    t.integer "gruponovid"
    t.index ["docid"], name: "novedad_docid_fk"
    t.index ["editorialid"], name: "novedad_editorialid_fk"
    t.index ["subid"], name: "novedad_subid_fk"
  end

  create_table "novedad_historico", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "subid"
    t.bigint "docid", null: false
    t.datetime "dateto"
    t.datetime "datefrom"
    t.integer "materiaid"
    t.boolean "athome", default: false, null: false
    t.string "autor", limit: 128
    t.string "comentario", limit: 1024
    t.boolean "destacado", default: false, null: false
    t.integer "gruponovid"
    t.integer "gmid"
    t.bigint "editorialid"
    t.datetime "fecha_creacion"
    t.datetime "fecha_borrado"
    t.boolean "to_latam", default: false, null: false
  end

  create_table "novedad_video", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "subid", null: false
    t.string "titulo", null: false
    t.string "descripcion", limit: 1024, null: false
    t.datetime "dateto"
    t.datetime "datefrom"
    t.string "url_image"
    t.index ["subid"], name: "novedad_video_subid_fk"
  end

  create_table "novedades_filters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "email", null: false
    t.string "ambitos_ids", limit: 64
    t.string "doctipo_ids", limit: 64
    t.datetime "created_at"
    t.integer "subid", default: 0, null: false
    t.index ["email", "subid"], name: "nvf_UNIQUE", unique: true
  end

  create_table "per_directory", primary_key: "directoryid", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "childcount"
    t.string "description", limit: 150, null: false
    t.bigint "parentdirectoryid"
    t.bigint "persubscription_id", null: false
    t.integer "type", null: false
    t.boolean "offline", default: false
    t.boolean "publica", default: false
    t.index ["parentdirectoryid"], name: "per_directory_parentdirectoryid_fk"
    t.index ["persubscription_id"], name: "per_directory_persubscription_id_fk"
  end

  create_table "per_directory_doc", primary_key: "perdocumentoid", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.datetime "creation_date"
    t.bigint "docid", null: false
    t.bigint "perdirectory_id", null: false
    t.string "titulo", limit: 500
    t.string "description"
    t.string "origen", limit: 5
    t.index ["perdirectory_id"], name: "per_directory_doc_perdirectory_id_fk"
  end

  create_table "per_directory_indexes", primary_key: "indexid", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "catid", null: false
    t.datetime "creation_date", null: false
    t.bigint "perdirectory_id", null: false
    t.string "description"
    t.string "titulo", limit: 500
    t.string "open_nodes", limit: 300
    t.string "selected_node", limit: 30
    t.string "url", limit: 300
    t.integer "tab", limit: 1
    t.index ["perdirectory_id"], name: "per_directory_indexes_perdirectory_id_fk"
  end

  create_table "per_directory_search", primary_key: "searchid", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "description", limit: 150, null: false
    t.datetime "fecha"
    t.string "url_varchar", limit: 500
    t.bigint "perdirectory_id", null: false
    t.integer "type"
    t.text "url"
    t.datetime "alert_lastdate"
    t.integer "alert_frequency"
    t.boolean "is_latam", default: false
    t.index ["perdirectory_id"], name: "per_directory_search_perdirectory_id_fk"
  end

  create_table "per_presubscription", primary_key: "presubscriptionid", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "clave"
    t.datetime "creation_date"
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
    t.string "password_digest"
    t.string "password_salt"
    t.string "password_digest_md5"
    t.string "confirmation_token"
  end

  create_table "per_subscription", primary_key: "subscriptionid", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.datetime "change_date"
    t.datetime "creation_date"
    t.string "perusuid", null: false
    t.integer "type"
    t.integer "usuarioid"
    t.integer "subid", default: 0, null: false
    t.datetime "fecha_alta_tablet"
    t.string "email_alta_tablet"
    t.string "token"
    t.datetime "fecha_last_login_tablet"
    t.boolean "acceso_tablet", default: false
    t.datetime "mydocs_change_date"
    t.datetime "mysearches_change_date"
    t.boolean "news", default: false, null: false
    t.bigint "oldsubscriptionid"
    t.integer "pais"
    t.boolean "countrynews", default: false, null: false
    t.string "nombre"
    t.string "apellidos"
    t.string "especialidad"
    t.string "telefono", limit: 16
    t.string "codigo_postal", limit: 8
    t.string "username"
    t.datetime "fecha_last_login"
    t.boolean "toolbar_casos_visible", default: true, null: false
    t.string "lang", limit: 3
    t.string "password_digest"
    t.string "password_salt"
    t.string "password_digest_md5"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.index ["subid"], name: "per_sub_id"
  end

  create_table "ponente_sinonimo", primary_key: ["nombre1", "nombre2"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "nombre1", null: false
    t.string "nombre2", null: false
    t.index ["nombre1"], name: "ponente_sinonimo_nombre1_ix"
    t.index ["nombre2"], name: "ponente_sinonimo_nombre2_ix"
  end

  create_table "producto", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", null: false
  end

  create_table "promocion", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "subid", null: false
    t.datetime "datefrom"
    t.datetime "dateto"
    t.datetime "fecha_creacion"
    t.string "link", limit: 1024
    t.string "descripcion", limit: 1024
    t.bigint "imagenid", null: false
    t.index ["imagenid"], name: "promocion_imagenid_fk"
    t.index ["subid"], name: "promocion_subid_fk"
  end

  create_table "seccionweb", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "nombre", limit: 100, null: false
  end

  create_table "servicio", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "clave", limit: 100, null: false
    t.bigint "moduloid"
    t.integer "subid", null: false
    t.integer "orden", null: false
    t.boolean "athome", default: false, null: false
    t.boolean "hide", default: false, null: false
    t.integer "grupoid"
    t.index ["grupoid"], name: "servicio_grupoid_fk"
    t.index ["moduloid"], name: "servicio_moduloid_fk"
    t.index ["subid"], name: "servicio_subid_fk"
  end

  create_table "solicitud_gratuita", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.datetime "fecha"
    t.string "keyword", limit: 128
    t.string "nombre", limit: 128
    t.string "email", limit: 256, null: false
    t.string "cp", limit: 8
    t.string "tipousuarioid", limit: 128
    t.string "telefono", limit: 16
    t.string "apellidos", limit: 128
    t.integer "subid", default: -1, null: false
  end

  create_table "solicitud_novedades_gratuitas", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.datetime "fecha"
    t.string "keyword", limit: 128
    t.string "nombre", limit: 128
    t.string "apellidos", limit: 128
    t.string "email", limit: 256, null: false
    t.string "cp", limit: 8
    t.string "telefono", limit: 16
    t.integer "subid", null: false
  end

  create_table "subsystem", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "name", null: false
    t.string "url"
    t.string "path"
    t.boolean "has_despachos", default: false, null: false
    t.boolean "show_demo", default: true, null: false
    t.boolean "show_alta_personalizacion", default: true, null: false
  end

  create_table "tipo_acceso", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", null: false
  end

  create_table "tipo_acceso_tablet", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", null: false
  end

  create_table "tipo_error_acceso", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", null: false
  end

  create_table "tipo_usuario_grupo", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", null: false
  end

  create_table "tipo_usuario_subsystem", primary_key: ["tipousuariogrupoid", "subid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "tipousuariogrupoid", null: false
    t.integer "subid", null: false
    t.index ["subid"], name: "tipousuariosubsystem_subid_fk"
  end

  create_table "tolusuarios_admin_role", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "authority", null: false
    t.index ["authority"], name: "authority", unique: true
  end

  create_table "tolusuarios_admin_user", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.boolean "account_expired", default: false, null: false
    t.boolean "account_locked", default: false, null: false
    t.boolean "enabled", default: false, null: false
    t.string "password", null: false
    t.boolean "password_expired", default: false, null: false
    t.string "username", null: false
    t.index ["username"], name: "username", unique: true
  end

  create_table "tolusuarios_admin_user_tolusuarios_admin_role", primary_key: ["tolusuarios_admin_role_id", "tolusuarios_admin_user_id"], force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "tolusuarios_admin_role_id", null: false
    t.bigint "tolusuarios_admin_user_id", null: false
    t.index ["tolusuarios_admin_role_id"], name: "FK5754074AE9E8CE"
    t.index ["tolusuarios_admin_user_id"], name: "FK5754074AA614ACAE"
  end

  create_table "tolusuarios_historico", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", null: false
    t.integer "grupoid"
    t.integer "tolusuarios_tipo_historico_id", null: false
    t.bigint "tolusuarios_admin_user_id", null: false
    t.bigint "usuarioid"
    t.index ["tolusuarios_admin_user_id"], name: "tolusuarios_admin_user_id"
    t.index ["tolusuarios_tipo_historico_id"], name: "tolusuarios_tipo_historico_id"
  end

  create_table "tolusuarios_tipo_historico", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", null: false
  end

  create_table "user_api_key", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "usuarioid", null: false
    t.string "api_key", limit: 16, null: false
    t.index ["usuarioid"], name: "user_api_key_usuarioid_fk"
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
    t.boolean "iscolectivo", default: false, null: false
    t.datetime "datelimit"
    t.boolean "actualizaciones", default: false, null: false
    t.datetime "fechaalta"
    t.string "nombre"
    t.string "apellidos"
    t.string "url_origen"
    t.integer "tipoaccesoid"
    t.boolean "isdemo", default: false, null: false
    t.integer "tipoaccesotabletid", default: 1, null: false
    t.string "dominios"
    t.integer "pais"
    t.string "nif", limit: 15
    t.integer "cloudlibrary_user"
    t.boolean "my_subscription_visible", default: true, null: false
    t.string "persona_contacto"
    t.string "direccion", limit: 500
    t.string "poblacion", limit: 500
    t.string "cp", limit: 500
    t.string "telefono", limit: 500
    t.string "fax", limit: 500
    t.boolean "independent_offices", default: false, null: false
    t.boolean "show_demo", default: false, null: false
    t.boolean "show_alta_personalizacion", default: false, null: false
    t.index ["cloudlibrary_user"], name: "index_usuario_on_cloudlibrary_user"
    t.index ["grupoid"], name: "usuario_grupoid_fk"
    t.index ["subid"], name: "usuario_subid_fk"
    t.index ["tipoaccesoid"], name: "usuario_tipoaccesoid_fk"
    t.index ["tipoaccesotabletid"], name: "usuario_tipoacceso_tablet_fk"
    t.index ["tipousuariogrupoid"], name: "usuario_tipousuariogrupoid_fk"
    t.index ["username"], name: "username_UNIQUE", unique: true
  end

  create_table "usuario_cloudlibrary", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "usuarioid", null: false
    t.string "cloud_user", default: "", null: false
    t.string "cloud_password"
    t.bigint "moduloid", null: false
    t.index ["usuarioid", "moduloid"], name: "an_index_name_for_c1_c2"
    t.index ["usuarioid"], name: "usuario_cloudlibrary_usuarioid_fk"
  end

  create_table "usuario_materia", primary_key: ["usuarioid", "materiaid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "usuarioid", default: 0, null: false
    t.integer "materiaid", default: 0, null: false
    t.index ["materiaid"], name: "usuario_materia_materiaid_fk"
  end

  create_table "usuario_modulo", primary_key: ["moduloid", "usuarioid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "moduloid", null: false
    t.bigint "usuarioid", null: false
    t.index ["usuarioid"], name: "usuario_modulo_usuarioid_fk"
  end

  create_table "usuario_producto", primary_key: ["productoid", "usuarioid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "productoid", null: false
    t.bigint "usuarioid", null: false
    t.index ["usuarioid"], name: "usuario_producto_usuarioid_fk"
  end

  create_table "usuario_recuerdame", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "usuario_id", null: false
    t.string "usuario_email", null: false
    t.string "cookie_id", null: false
  end

  create_table "usuario_stats", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "usuario_id", null: false
    t.datetime "fecha"
    t.integer "sesiones", null: false
    t.integer "documentos", null: false
    t.index ["fecha"], name: "idx_fecha"
    t.index ["usuario_id", "fecha"], name: "idx_usuarioid_fecha"
    t.index ["usuario_id"], name: "idx_usuarioid"
    t.index ["usuario_id"], name: "usuario_usuario_id_fk"
  end

  create_table "usuarioconexiones", primary_key: "usuarioid", id: :bigint, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "numconexiones", null: false
  end

  add_foreign_key "banner", "subsystem", column: "subid", name: "banner_subid_fk"
  add_foreign_key "banner_boletin_novedades", "catalogo_banner", column: "imagen", name: "banner_boletin_novedades_imagen_fk"
  add_foreign_key "contactos_comerciales", "subsystem", column: "subid", name: "contactos_comerciales_subid_fk"
  add_foreign_key "docindice", "ambito", primary_key: "ambitoid", name: "docindice_ambito_id_fk"
  add_foreign_key "docindice", "docindice", column: "parentid", primary_key: "catid", name: "docindice_parent_id_fk"
  add_foreign_key "docindice_materia", "docindice", column: "catid", primary_key: "catid", name: "docindice_materia_catid_fk"
  add_foreign_key "docindice_materia", "materia", column: "materiaid", name: "docindice_materia_materiaid_fk"
  add_foreign_key "docindice_settings", "docindice", column: "catid", primary_key: "catid", name: "docindice_settings_catid_fk"
  add_foreign_key "doctrina_autor", "despdautor", column: "autor_id", name: "doctrina_autor_autor_id_fk"
  add_foreign_key "doctrina_autor", "libro_doctrina", name: "doctrina_autor_libro_doctrina_id_fk"
  add_foreign_key "documento_ambito", "ambito", primary_key: "ambitoid", name: "documento_ambito_ambitoid_fk"
  add_foreign_key "documento_ambito", "documento", primary_key: "docid", name: "documento_ambito_docid_fk"
  add_foreign_key "error_acceso", "tipo_error_acceso", name: "error_acceso_tipo_error_acceso_id_fk"
  add_foreign_key "gm_materia", "grupo_materia", column: "gmid", name: "gm_materia_gmid_fk"
  add_foreign_key "gm_materia", "materia", column: "materiaid", name: "gm_materia_materiaid_fk"
  add_foreign_key "gm_servicio", "grupo_materia", column: "gmid", name: "gm_servicio_ibfk_1"
  add_foreign_key "gm_servicio", "servicio", column: "servicioid", name: "gm_servicio_ibfk_2"
  add_foreign_key "gm_usuario", "grupo_materia", column: "gmid", name: "gm_usuario_grupomateriaid_fk"
  add_foreign_key "gm_usuario", "usuario", column: "usuarioid", name: "gm_usuario_usuarioid_fk"
  add_foreign_key "grupo", "tipo_usuario_grupo", column: "tipoid", name: "grupo_tipoid_fk"
  add_foreign_key "grupo_servicio", "subsystem", column: "subid", name: "grupo_servicio_subid_fk"
  add_foreign_key "li_enlace", "li_pais", column: "pais_id", name: "li_enlace_ibfk_1"
  add_foreign_key "li_pais", "li_continente", column: "continente_id", name: "li_pais_ibfk_1"
  add_foreign_key "materia_subsystem", "materia", column: "materiaid", name: "materia_subsystem_materiaid_fk"
  add_foreign_key "materia_subsystem", "subsystem", column: "subid", name: "materia_subsystem_subid_fk"
  add_foreign_key "modulo_premium_subsystem", "modulo", column: "moduloid", name: "modulo_premium_subsystem_moduloid_fk"
  add_foreign_key "modulo_premium_subsystem", "subsystem", column: "subid", name: "modulo_premium_subsystem_subid_fk"
  add_foreign_key "modulo_subsystem", "modulo", column: "moduloid", name: "modulo_subsystem_moduloid_fk"
  add_foreign_key "modulo_subsystem", "subsystem", column: "subid", name: "modulo_subsystem_subid_fk"
  add_foreign_key "novedad", "despeditorial", column: "editorialid", name: "novedad_editorialid_fk"
  add_foreign_key "novedad", "documento", column: "docid", primary_key: "docid", name: "novedad_docid_fk"
  add_foreign_key "novedad", "subsystem", column: "subid", name: "novedad_subid_fk"
  add_foreign_key "novedad_video", "subsystem", column: "subid", name: "novedad_video_subid_fk"
  add_foreign_key "per_directory", "per_directory", column: "parentdirectoryid", primary_key: "directoryid", name: "per_directory_parentdirectoryid_fk"
  add_foreign_key "per_directory", "per_subscription", column: "persubscription_id", primary_key: "subscriptionid", name: "per_directory_persubscription_id_fk"
  add_foreign_key "per_directory_doc", "per_directory", column: "perdirectory_id", primary_key: "directoryid", name: "per_directory_doc_perdirectory_id_fk"
  add_foreign_key "per_directory_indexes", "per_directory", column: "perdirectory_id", primary_key: "directoryid", name: "per_directory_indexes_perdirectory_id_fk"
  add_foreign_key "per_directory_search", "per_directory", column: "perdirectory_id", primary_key: "directoryid", name: "per_directory_search_perdirectory_id_fk"
  add_foreign_key "per_subscription", "subsystem", column: "subid", name: "per_subscription_subid_fk"
  add_foreign_key "promocion", "catalogo_banner", column: "imagenid", name: "promocion_imagenid_fk"
  add_foreign_key "promocion", "subsystem", column: "subid", name: "promocion_subid_fk"
  add_foreign_key "servicio", "grupo_servicio", column: "grupoid", name: "servicio_grupoid_fk"
  add_foreign_key "servicio", "modulo", column: "moduloid", name: "servicio_moduloid_fk"
  add_foreign_key "servicio", "subsystem", column: "subid", name: "servicio_subid_fk"
  add_foreign_key "tipo_usuario_subsystem", "subsystem", column: "subid", name: "tipousuariosubsystem_subid_fk"
  add_foreign_key "tipo_usuario_subsystem", "tipo_usuario_grupo", column: "tipousuariogrupoid", name: "tipousuariosubsystem_tipousuariogrupoid_fk"
  add_foreign_key "user_api_key", "usuario", column: "usuarioid", name: "user_api_key_usuarioid_fk", on_delete: :cascade
  add_foreign_key "userips", "usuario", column: "usuarioid", name: "userips_usuarioid_fk", on_delete: :cascade
  add_foreign_key "usuario", "grupo", column: "grupoid", name: "usuario_grupoid_fk"
  add_foreign_key "usuario", "subsystem", column: "subid", name: "usuario_subid_fk"
  add_foreign_key "usuario", "tipo_acceso", column: "tipoaccesoid", name: "usuario_tipoaccesoid_fk"
  add_foreign_key "usuario", "tipo_acceso_tablet", column: "tipoaccesotabletid", name: "usuario_tipoacceso_tablet_fk"
  add_foreign_key "usuario", "tipo_usuario_grupo", column: "tipousuariogrupoid", name: "usuario_tipousuariogrupoid_fk"
  add_foreign_key "usuario_materia", "materia", column: "materiaid", name: "usuario_materia_materiaid_fk"
  add_foreign_key "usuario_materia", "usuario", column: "usuarioid", name: "usuario_materia_usuarioid_fk", on_delete: :cascade
  add_foreign_key "usuario_modulo", "modulo", column: "moduloid", name: "usuario_modulo_moduloid_fk"
  add_foreign_key "usuario_modulo", "usuario", column: "usuarioid", name: "usuario_modulo_usuarioid_fk"
  add_foreign_key "usuario_producto", "producto", column: "productoid", name: "usuario_producto_productoid_fk"
  add_foreign_key "usuario_producto", "usuario", column: "usuarioid", name: "usuario_producto_usuarioid_fk"
  add_foreign_key "usuarioconexiones", "usuario", column: "usuarioid", name: "usuarioconexiones_usuarioid_fk"
end
