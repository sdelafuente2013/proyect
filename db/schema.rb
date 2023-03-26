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

  create_table "al_alerta_convenio", primary_key: "alertaid", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "convenioid", null: false
    t.string "descripcion", limit: 1024, null: false
    t.bigint "subscriptionid", null: false
    t.datetime "fechaenvio"
    t.index ["subscriptionid"], name: "al_alerta_convenio_subscriptionid_fk"
  end

  create_table "al_alerta_subvencion", primary_key: "alertaid", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "ambitoid", null: false
    t.bigint "autonomiaid"
    t.string "descripcion", limit: 150, null: false
    t.bigint "materiaid", null: false
    t.bigint "subscriptionid", null: false
    t.datetime "fechaenvio"
    t.index ["ambitoid"], name: "al_alerta_subvencion_al_ambitoid"
    t.index ["autonomiaid"], name: "al_alerta_subvencion_al_autonomiaid"
    t.index ["materiaid"], name: "al_alerta_subvencion_al_materiaid"
    t.index ["subscriptionid"], name: "al_alerta_subvencion_subscriptionid_fk"
  end

  create_table "al_ambito", primary_key: "ambitoid", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", null: false
  end

  create_table "al_autonomia", primary_key: "autonomiaid", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", limit: 150, null: false
  end

  create_table "al_convenio", primary_key: "convenioid", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "codigo14", limit: 14
    t.string "codigo7", limit: 7
    t.integer "counter"
    t.string "descripcion", limit: 1024, null: false
    t.bigint "origenid", null: false
    t.bigint "idgsb", default: 0, null: false
    t.index ["origenid"], name: "al_convenio_origenid_fk"
  end

  create_table "al_convenio_solr", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "convenioid", null: false
    t.string "solr_id", null: false
    t.boolean "enviado", null: false
    t.boolean "confirmado", null: false
    t.string "titulo", limit: 1024, null: false
    t.string "solr_id_new"
    t.index ["convenioid"], name: "convenioid"
  end

  create_table "al_convenio_solr_all", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "convenioid", null: false
    t.string "solr_id", limit: 250, null: false
    t.string "solr_id_new"
  end

  create_table "al_materia", primary_key: "materiaid", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", limit: 150, null: false
    t.integer "orden", null: false
  end

  create_table "al_origen", primary_key: "origenid", id: :bigint, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", limit: 150, null: false
    t.integer "orden"
    t.integer "parentid"
  end

  create_table "al_subvencion_solr", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "ambitoid", null: false
    t.bigint "autonomiaid"
    t.string "denominacion", limit: 1024, null: false
    t.boolean "enviado", null: false
    t.bigint "materiaid", null: false
    t.string "solr_id", null: false
    t.index ["ambitoid"], name: "al_subvencion_solr_ambitoid"
    t.index ["materiaid"], name: "al_subvencion_solr_materiaid"
  end

  create_table "alert_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "app_id", null: false
    t.string "email", null: false
    t.datetime "created_at"
    t.index ["app_id", "email"], name: "index_alert_users_on_app_id_and_email", unique: true
  end

  create_table "alertas_convenios_sent", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "convenioid", null: false
    t.datetime "fechaenvio", null: false
    t.bigint "subscriptionid", null: false
    t.index ["convenioid"], name: "alertas_convenios_sent_convenioid"
    t.index ["subscriptionid"], name: "alertas_convenios_sent_subscriptionid"
  end

  create_table "alertas_subvenciones_sent", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "ambitoid", null: false
    t.bigint "autonomiaid"
    t.datetime "fechaenvio", null: false
    t.bigint "materiaid", null: false
    t.bigint "subscriptionid", null: false
    t.index ["ambitoid"], name: "alertas_subvenciones_sent_ambitoid"
    t.index ["autonomiaid"], name: "alertas_subvenciones_sent_autonomiaid"
    t.index ["materiaid"], name: "alertas_subvenciones_sent_materiaid"
    t.index ["subscriptionid"], name: "alertas_subvenciones_sent_subscriptionid"
  end

  create_table "alerts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "app_id", null: false
    t.bigint "document_id", null: false
    t.datetime "alert_date"
    t.bigint "alertable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "alertable_type", default: "Esp::AlertUser"
    t.string "document_tolgeo", default: "esp", null: false
    t.index ["alertable_id", "alertable_type"], name: "index_alerts_on_alertable_id_and_alertable_type"
    t.index ["alertable_id"], name: "index_alerts_on_alertable_id"
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

  create_table "ambito", primary_key: "ambitoid", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "nombre", limit: 30, null: false
    t.integer "orden", null: false
  end

  create_table "app_message", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "code", limit: 200, null: false
    t.string "locale", limit: 10, null: false
    t.string "text", limit: 500, null: false
    t.index ["code", "locale"], name: "idx_message_key", unique: true
  end

  create_table "autor_bibliografia", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
  end

  create_table "backoffice_user_roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "backoffice_user_id"
    t.bigint "role_id"
    t.index ["backoffice_user_id", "role_id"], name: "by_backoffice_user_role", unique: true
    t.index ["backoffice_user_id"], name: "index_backoffice_user_roles_on_backoffice_user_id"
    t.index ["role_id"], name: "index_backoffice_user_roles_on_role_id"
  end

  create_table "backoffice_user_subsystems", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "subsystem_id", null: false
    t.bigint "backoffice_user_tolgeo_id"
    t.index ["backoffice_user_tolgeo_id", "subsystem_id"], name: "by_tolgeo_subsystem", unique: true
    t.index ["backoffice_user_tolgeo_id"], name: "index_backoffice_user_subsystems_on_backoffice_user_tolgeo_id"
  end

  create_table "backoffice_user_tolgeos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "backoffice_user_id", null: false
    t.bigint "tolgeo_id"
    t.index ["tolgeo_id", "backoffice_user_id"], name: "by_tolgeo_user", unique: true
    t.index ["tolgeo_id"], name: "index_backoffice_user_tolgeos_on_tolgeo_id"
  end

  create_table "backoffice_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "email", null: false
    t.datetime "last_login"
    t.boolean "active", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "admin", default: false
    t.integer "tolgeo_default_id", default: 0
    t.string "password_digest"
    t.index ["email"], name: "index_backoffice_users_on_email", unique: true
  end

  create_table "banner", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "subid", null: false
    t.integer "orden", null: false
    t.string "file_name", null: false
    t.integer "gmid"
    t.string "url"
    t.index ["gmid"], name: "banner_gmid_fk"
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

  create_table "bibliografia_extraction_config", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.datetime "fecha_ejecucion", null: false
  end

  create_table "boletin", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.binary "activo", limit: 1, null: false
    t.datetime "fecha", null: false
    t.string "nombre", null: false
    t.bigint "pais_id"
    t.integer "subid", null: false
    t.index ["subid"], name: "subid", unique: true
  end

  create_table "cat_alta", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.datetime "fechaalta"
    t.datetime "fechasolicitud"
    t.string "nombre", limit: 128
    t.string "nif", limit: 16
    t.string "colegio", limit: 128
    t.string "ncolegio", limit: 32
    t.string "email", limit: 256, null: false
    t.string "direccion", limit: 256
    t.string "poblacion", limit: 128
    t.string "provincia", limit: 128
    t.string "cp", limit: 8
    t.string "pais", limit: 128
    t.string "telfijo", limit: 16
    t.string "telmovil", limit: 16
    t.string "tipousuarioid", limit: 128
  end

  create_table "cat_solicitud", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.datetime "fecha"
    t.string "keyword", limit: 128
    t.string "nombre", limit: 128
    t.string "nif", limit: 16
    t.string "colegio", limit: 128
    t.string "ncolegio", limit: 32
    t.string "email", limit: 256, null: false
    t.string "direccion", limit: 256
    t.string "poblacion", limit: 128
    t.string "provincia", limit: 128
    t.string "cp", limit: 8
    t.string "pais", limit: 128
    t.string "telfijo", limit: 16
    t.string "telmovil", limit: 16
    t.string "tipousuarioid", limit: 128
  end

  create_table "catalogo_banner", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "filename", null: false
    t.string "titulo", null: false
    t.string "sizeimg", limit: 16, null: false
  end

  create_table "ccss_faq_preguntas_subidas", primary_key: "id_pregunta", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "docxml"
    t.index ["docxml"], name: "docxml_UNIQUE", unique: true
    t.index ["id_pregunta"], name: "id_pregunta_UNIQUE", unique: true
  end

  create_table "ccss_faq_preguntas_subidas_old", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "id_pregunta"
    t.bigint "subida"
    t.string "docxml"
  end

  create_table "ccss_faq_temas_indices", primary_key: "id_tema", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "catid", limit: 100
  end

  create_table "configuracion", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "module_id", limit: 64, null: false
    t.datetime "ult_actualizacion", null: false
    t.bigint "ult_module_seq"
    t.datetime "ult_historico"
    t.bigint "hist_atras_hasta"
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

  create_table "despcemisor", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "emisor", limit: 100, null: false
    t.integer "orden", null: false
  end

  create_table "despctipo", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "tipo", limit: 50, null: false
    t.integer "orden", null: false
  end

  create_table "despdautor", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "autor", limit: 500, null: false
    t.integer "orden", null: false
  end

  create_table "despdrevista", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "nombre", null: false
    t.integer "orden", null: false
  end

  create_table "despeditorial", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "codigo", limit: 25
    t.string "nombre", null: false
  end

  create_table "despfemisor", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "emisor", limit: 100, null: false
    t.integer "orden", null: false
  end

  create_table "desppaislatam", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "codigo", null: false
    t.string "codigo_iso", limit: 3, null: false
    t.string "nombre", limit: 256, null: false
    t.integer "subid", null: false
    t.string "codigo_iso_2digits"
  end

  create_table "despsfallo", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "nombre", limit: 100, null: false
    t.integer "orden", null: false
  end

  create_table "despsjurisdiccion", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "jurisdicdesc", limit: 100, null: false
    t.integer "orden", null: false
  end

  create_table "despsorigen", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "padre_id"
    t.string "origen", limit: 100, null: false
    t.integer "orden", null: false
    t.integer "peso"
    t.integer "tipo"
    t.boolean "asignable"
    t.string "origen_regexp", limit: 200
  end

  create_table "despspais", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", limit: 256, null: false
    t.string "descripcioncas", limit: 256, null: false
    t.integer "orden", null: false
  end

  create_table "despsponente", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "orden", null: false
    t.string "ponente", null: false
  end

  create_table "despssala", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "sala", limit: 100, null: false
    t.integer "orden", null: false
  end

  create_table "despsseccion", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "seccion", limit: 100, null: false
    t.integer "orden", null: false
  end

  create_table "despstipo", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "tipo", null: false
    t.integer "orden", null: false
  end

  create_table "desptipodoctrina", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "tipo", limit: 50, null: false
    t.integer "orden", null: false
    t.boolean "es_revista"
  end

  create_table "desptipotextolegal", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "tipo", limit: 50, null: false
    t.integer "orden", null: false
  end

  create_table "desptlocalidad", primary_key: "localidadid", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "organismoid", null: false
    t.string "descripcion", limit: 120, null: false
    t.integer "orden", null: false
    t.index ["organismoid"], name: "desptlocalidad_organismoid_fk"
  end

  create_table "desptorganismo", primary_key: "organismoid", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", limit: 120, null: false
    t.bigint "provinciaid", null: false
    t.integer "orden", null: false
    t.index ["provinciaid"], name: "desptorganismo_provinciaid_fk"
  end

  create_table "desptprovincia", primary_key: "provinciaid", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", limit: 120, null: false
    t.integer "orden", null: false
    t.string "imagen"
  end

  create_table "desptrango", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "rango", limit: 100, null: false
    t.integer "orden", null: false
  end

  create_table "desptsboletin", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "boletin", null: false
    t.integer "orden", null: false
  end

  create_table "docindice", primary_key: "catid", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "parentid"
    t.string "descripcion", limit: 500, null: false
    t.boolean "hoja", null: false
    t.bigint "orden"
    t.bigint "orderabs"
    t.integer "ambito_id"
    t.integer "profundidad"
    t.boolean "no_despliega_en_web", default: false
    t.boolean "contiene_redacciones", default: false
    t.boolean "en_vacatio"
    t.index ["ambito_id"], name: "docindice_ambito_id_fk"
    t.index ["descripcion"], name: "docindice_descripcion_ix", length: { descripcion: 255 }
    t.index ["parentid"], name: "docindice_parent_id_ix"
  end

  create_table "docindice_antecesores", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "catid"
    t.bigint "parentid"
    t.integer "profundidad", null: false
    t.index ["catid", "parentid", "profundidad"], name: "docindice_antecesores_unique_ix", unique: true
  end

  create_table "docindice_busquedas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "catid", null: false
    t.string "busqueda", limit: 500, null: false
  end

  create_table "docindice_idiomas", primary_key: ["catid", "idiomaid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "catid", null: false
    t.integer "idiomaid", null: false
    t.string "descripcion", limit: 500, null: false
  end

  create_table "docindice_materia", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "catid"
    t.integer "materiaid"
    t.index ["catid"], name: "docindice_materia_catid_fk"
    t.index ["materiaid"], name: "docindice_materia_materiaid_fk"
  end

  create_table "docindice_process", id: :string, limit: 50, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "value"
  end

  create_table "docindice_search", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "catid", null: false
    t.bigint "rootid"
    t.text "descripcion", null: false
    t.integer "ambito"
    t.integer "materiaid"
    t.boolean "hoja"
    t.boolean "derogada", default: false
    t.index ["descripcion"], name: "descripcion", type: :fulltext
  end

  create_table "docindice_settings", primary_key: "catid", id: :bigint, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.boolean "voz", default: false, null: false
    t.integer "nivel_voces_id"
    t.datetime "fecha"
    t.boolean "homelink", default: false, null: false
    t.string "keywords"
    t.boolean "nube_voces", default: false, null: false
    t.bigint "documento_principal_id"
    t.boolean "derogada", default: false
    t.index ["nivel_voces_id"], name: "docindice_settings_nivel_voces_id_fk"
    t.index ["voz"], name: "docindice_settings_voz_ix"
  end

  create_table "docs_analizados", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "doc_id", limit: 100, null: false
    t.string "module_id", limit: 64, null: false
    t.bigint "module_seq", null: false
    t.string "doc_hash", limit: 64
    t.boolean "versiones", default: false, null: false
  end

  create_table "docterminos", primary_key: ["familiaid", "docid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "familiaid", null: false
    t.bigint "docid", null: false
  end

  create_table "doctipo", primary_key: "tipoid", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "nombre", null: false
    t.boolean "check_permisos", default: true
  end

  create_table "doctipointeres", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "tipo", limit: 50, null: false
    t.integer "orden", null: false
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
    t.string "titulodoc", default: "", null: false
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

  create_table "documento_enlaces_delete", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "docid", null: false
    t.bigint "docid_enlace", null: false
    t.index ["docid"], name: "documento_enlaces_del_docid_ix"
    t.index ["docid_enlace"], name: "documento_enlaces_del_docid_enlace_ix"
  end

  create_table "documento_referencia", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "docid", null: false
    t.bigint "docid_enlace", null: false
    t.index ["docid"], name: "documento_referencia_docid_ix"
    t.index ["docid_enlace"], name: "documento_referencia_docid_enlace_ix"
  end

  create_table "documento_referencia_delete", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "docid", null: false
    t.bigint "docid_enlace", null: false
    t.index ["docid"], name: "documento_referencia_del_docid_ix"
    t.index ["docid_enlace"], name: "documento_referencia_del_docid_enlace_ix"
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
    t.string "dominios"
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
    t.index ["componente"], name: "indice_composicion_asignaciones_componente_ix"
    t.index ["compuesto"], name: "indice_composicion_asignaciones_compuesto_ix"
  end

  create_table "indice_recomendados", primary_key: ["catid", "recomendado"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "catid", null: false
    t.bigint "recomendado", null: false
    t.index ["catid"], name: "docindice_sinonimos_origen_ix"
    t.index ["recomendado"], name: "docindice_sinonimos_destino_ix"
  end

  create_table "ips_privadas", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "ip", limit: 21, null: false
  end

  create_table "isbn_portada", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "isbn", null: false
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

  create_table "lopd_aceptacion_temporal", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "external_id", null: false
    t.string "external_type", null: false
    t.boolean "aceptada_lopd_comercial", default: false
    t.boolean "aceptada_lopd_grupo", default: false
    t.boolean "aceptada_lopd", default: false
  end

  create_table "lopd_ambito_usuario", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "external_id", null: false
    t.string "external_type", null: false
    t.string "lopd_ambito"
  end

  create_table "materia", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "nombre", null: false
    t.string "tema", null: false
    t.bigint "permisos_decimal", null: false
    t.string "permisos_binario", null: false
  end

  create_table "materia_indice_root", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "catid", null: false
    t.integer "materiaid", null: false
    t.index ["catid"], name: "catid"
    t.index ["materiaid"], name: "materiaid"
  end

  create_table "materia_producto", primary_key: ["productoid", "materiaid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "productoid", null: false
    t.integer "materiaid", null: false
    t.index ["materiaid"], name: "materiaid"
  end

  create_table "materia_seccionweb", primary_key: ["materiaid", "seccionid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "seccionid", null: false
    t.integer "materiaid", null: false
    t.integer "orden", null: false
    t.index ["seccionid"], name: "materia_seccionweb_seccionid_fk"
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
    t.integer "subid"
    t.bigint "docid", null: false
    t.datetime "dateto"
    t.datetime "datefrom"
    t.integer "materiaid"
    t.boolean "athome", default: false
    t.string "autor", limit: 128
    t.string "comentario", limit: 1024
    t.boolean "destacado", default: false
    t.integer "gruponovid"
    t.integer "gmid"
    t.bigint "editorialid"
    t.datetime "fecha_creacion"
    t.boolean "to_latam", default: false
    t.index ["docid"], name: "novedad_docid_fk"
    t.index ["editorialid"], name: "novedad_editorialid_fk"
    t.index ["gmid"], name: "novedad_gmid_fk"
    t.index ["gruponovid"], name: "novedad_gruponovid_fk"
    t.index ["subid"], name: "novedad_subid_fk"
  end

  create_table "novedad_historico", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "subid"
    t.bigint "docid", null: false
    t.datetime "dateto"
    t.datetime "datefrom"
    t.integer "materiaid"
    t.boolean "athome"
    t.string "autor", limit: 128
    t.string "comentario", limit: 1024
    t.boolean "destacado"
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
    t.string "materias_ids", limit: 64
    t.string "ambitos_ids", limit: 64
    t.string "doctipo_ids", limit: 64
    t.string "grupo_novedades_ids", limit: 64
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
    t.integer "materia", limit: 1
    t.index ["perdirectory_id"], name: "per_directory_indexes_perdirectory_id_fk"
  end

  create_table "per_directory_search", primary_key: "searchid", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "description", limit: 150
    t.datetime "fecha"
    t.string "url_varchar", limit: 500
    t.bigint "perdirectory_id", null: false
    t.integer "type"
    t.text "url"
    t.datetime "alert_lastdate"
    t.integer "alert_frequency"
    t.boolean "is_latam"
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
    t.bigint "usuarioid"
    t.bigint "oldsubscriptionid"
    t.integer "pais"
    t.boolean "countrynews", default: true, null: false
    t.datetime "mydocs_change_date"
    t.datetime "mysearches_change_date"
    t.integer "subid", default: 0, null: false
    t.datetime "fecha_alta_tablet"
    t.string "email_alta_tablet"
    t.string "token"
    t.datetime "fecha_last_login_tablet"
    t.boolean "acceso_tablet", default: false
    t.boolean "news", default: true, null: false
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

  create_table "pmt_grupomateria_novedad", primary_key: ["pmtid", "grupomateriaid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "pmtid", null: false
    t.integer "grupomateriaid", null: false
  end

  create_table "pmt_subsystem_gruponovedades_novedad", primary_key: ["pmtid", "subid", "gruponovedadid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "pmtid", null: false
    t.integer "subid", null: false
    t.integer "gruponovedadid", null: false
  end

  create_table "pmt_subsystem_materia_novedad", primary_key: ["pmtid", "subid", "materiaid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "pmtid", null: false
    t.integer "subid", null: false
    t.integer "materiaid", null: false
  end

  create_table "pmt_subsystem_novedad", primary_key: ["pmtid", "subid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "pmtid", null: false
    t.integer "subid", null: false
  end

  create_table "ponente_sinonimo", primary_key: ["nombre1", "nombre2"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "nombre1", null: false
    t.string "nombre2", null: false
    t.index ["nombre1"], name: "ponente_sinonimo_nombre1_ix"
    t.index ["nombre2"], name: "ponente_sinonimo_nombre2_ix"
  end

  create_table "prefijo_materia_tirant", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "prefixlib", limit: 30, null: false
    t.integer "ambito", null: false
  end

  create_table "producto", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", null: false
    t.boolean "activo", default: false, null: false
  end

  create_table "producto_jurisdiccion", primary_key: ["productoid", "jurisdiccionid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "productoid", null: false
    t.integer "jurisdiccionid", null: false
    t.index ["jurisdiccionid"], name: "producto_jurisdiccion_jurisdiccion_fk"
  end

  create_table "producto_origen", primary_key: ["productoid", "origenid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "productoid", null: false
    t.integer "origenid", null: false
    t.index ["origenid"], name: "producto_origen_origenid_fk"
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

  create_table "promocion_formacion", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "subid", null: false
    t.datetime "datefrom"
    t.datetime "dateto"
    t.string "comentario", limit: 1024, null: false
    t.string "titulo", limit: 1024, null: false
    t.integer "idpromo", default: 0, null: false
    t.string "link", limit: 1024, null: false
    t.string "textlink", limit: 1024, null: false
    t.datetime "fecha_creacion"
    t.index ["subid"], name: "promocion_formacion_subid_fk"
  end

  create_table "promocion_formacion_historico", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "subid", null: false
    t.datetime "datefrom"
    t.datetime "dateto"
    t.string "comentario", limit: 1024, null: false
    t.string "titulo", limit: 1024, null: false
    t.integer "idpromo", default: 0, null: false
    t.string "link", limit: 1024, null: false
    t.string "textlink", limit: 1024, null: false
    t.datetime "fecha_creacion"
    t.datetime "fecha_borrado"
  end

  create_table "promocion_historico", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "subid", null: false
    t.datetime "datefrom"
    t.datetime "dateto"
    t.integer "tipoid", null: false
    t.string "comentario", limit: 1024, null: false
    t.string "titulo", limit: 1024, null: false
    t.datetime "fecha_creacion"
    t.datetime "fecha_borrado"
    t.integer "idpromo", default: 0, null: false
    t.string "link", limit: 1024
    t.string "textlink", limit: 1024
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "description", null: false
    t.index ["description"], name: "index_roles_on_description", unique: true
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
    t.boolean "hide", default: false
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

  create_table "task_records", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "version", null: false
  end

  create_table "terminos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", limit: 1000, null: false
    t.bigint "catid"
    t.bigint "familiaid"
    t.boolean "hassinonimosrt"
    t.boolean "hasresumen"
    t.boolean "voz"
    t.boolean "userok"
  end

  create_table "tipo_acceso", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", null: false
  end

  create_table "tipo_acceso_tablet", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", null: false
  end

  create_table "tipo_error_acceso", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", null: false
  end

  create_table "tipo_promocion", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "imagen"
    t.string "titulo", limit: 1024
    t.string "descripcion", limit: 1024
  end

  create_table "tipo_usuario_grupo", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "descripcion", null: false
  end

  create_table "tipo_usuario_subsystem", primary_key: ["tipousuariogrupoid", "subid"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "tipousuariogrupoid", null: false
    t.integer "subid", null: false
    t.integer "orden", default: 0
    t.index ["subid"], name: "tipousuariosubsystem_subid_fk"
  end

  create_table "tolgeos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.index ["name"], name: "index_tolgeos_on_name", unique: true
  end

  create_table "tolusuarios_admin_role", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "authority", null: false
    t.index ["authority"], name: "authority", unique: true
  end

  create_table "tolusuarios_admin_user", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.boolean "account_expired", null: false
    t.boolean "account_locked", null: false
    t.boolean "enabled", null: false
    t.string "password", null: false
    t.boolean "password_expired", null: false
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

  create_table "ufile", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "size"
    t.string "path", limit: 100
    t.string "name", limit: 100
    t.string "extension", limit: 10
    t.datetime "date_uploaded"
    t.integer "downloads"
    t.integer "version"
  end

  create_table "update_docindice_orderabs", primary_key: "catid", id: :bigint, default: nil, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "orderabs"
  end

  create_table "user_api_key", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "usuarioid", null: false
    t.string "api_key", limit: 16, null: false
    t.index ["usuarioid"], name: "user_api_key_usuarioid_fk"
  end

  create_table "user_tmp", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "id", null: false
    t.string "username", limit: 128, null: false, collation: "utf8_bin"
    t.string "consultoria", limit: 2
    t.string "biblioteca", limit: 2
  end

  create_table "user_tmp2", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "id", null: false
    t.string "username", limit: 128, null: false, collation: "utf8_bin"
    t.string "consultoria", limit: 2
    t.string "biblioteca", limit: 2
    t.integer "ischecked"
  end

  create_table "userips", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "usuarioid", null: false
    t.string "ipfrom", null: false
    t.string "ipto", null: false
    t.index ["usuarioid"], name: "userips_usuarioid_fk"
  end

  create_table "usuario", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "username", null: false, collation: "utf8_bin"
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
    t.string "persona_contacto"
    t.string "direccion"
    t.string "poblacion"
    t.string "cp", limit: 10
    t.string "telefono"
    t.string "fax", limit: 15
    t.integer "cloudlibrary_user"
    t.boolean "my_subscription_visible", default: true, null: false
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

  create_table "usuario_tmp", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "nombre", limit: 256
    t.string "telefono", limit: 128
    t.string "email", limit: 256
    t.string "username", limit: 128, null: false, collation: "utf8_bin"
    t.string "password", limit: 128
    t.integer "id"
  end

  create_table "usuarioconexiones", primary_key: "usuarioid", id: :bigint, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.integer "numconexiones", null: false
  end

  add_foreign_key "al_alerta_convenio", "per_subscription", column: "subscriptionid", primary_key: "subscriptionid", name: "al_alerta_convenio_subscriptionid_fk"
  add_foreign_key "al_alerta_subvencion", "al_ambito", column: "ambitoid", primary_key: "ambitoid", name: "al_alerta_subvencion_al_ambitoid"
  add_foreign_key "al_alerta_subvencion", "al_autonomia", column: "autonomiaid", primary_key: "autonomiaid", name: "al_alerta_subvencion_al_autonomiaid"
  add_foreign_key "al_alerta_subvencion", "al_materia", column: "materiaid", primary_key: "materiaid", name: "al_alerta_subvencion_al_materiaid"
  add_foreign_key "al_alerta_subvencion", "per_subscription", column: "subscriptionid", primary_key: "subscriptionid", name: "al_alerta_subvencion_subscriptionid_fk"
  add_foreign_key "al_convenio", "al_origen", column: "origenid", primary_key: "origenid", name: "al_convenio_origenid_fk"
  add_foreign_key "al_convenio_solr", "al_convenio", column: "convenioid", primary_key: "convenioid", name: "al_convenio_solr_ibfk_1"
  add_foreign_key "al_subvencion_solr", "al_ambito", column: "ambitoid", primary_key: "ambitoid", name: "al_subvencion_solr_ambitoid"
  add_foreign_key "al_subvencion_solr", "al_materia", column: "materiaid", primary_key: "materiaid", name: "al_subvencion_solr_materiaid"
  add_foreign_key "alertas_convenios_sent", "al_convenio", column: "convenioid", primary_key: "convenioid", name: "alertas_convenios_sent_convenioid"
  add_foreign_key "alertas_subvenciones_sent", "al_ambito", column: "ambitoid", primary_key: "ambitoid", name: "alertas_subvenciones_sent_ambitoid"
  add_foreign_key "alertas_subvenciones_sent", "al_autonomia", column: "autonomiaid", primary_key: "autonomiaid", name: "alertas_subvenciones_sent_autonomiaid"
  add_foreign_key "alertas_subvenciones_sent", "al_materia", column: "materiaid", primary_key: "materiaid", name: "alertas_subvenciones_sent_materiaid"
  add_foreign_key "backoffice_user_roles", "backoffice_users"
  add_foreign_key "backoffice_user_roles", "roles"
  add_foreign_key "backoffice_user_subsystems", "backoffice_user_tolgeos"
  add_foreign_key "backoffice_user_tolgeos", "tolgeos"
  add_foreign_key "banner", "grupo_materia", column: "gmid", name: "banner_gmid_fk"
  add_foreign_key "banner", "subsystem", column: "subid", name: "banner_subid_fk"
  add_foreign_key "banner_boletin_novedades", "catalogo_banner", column: "imagen", name: "banner_boletin_novedades_imagen_fk"
  add_foreign_key "contactos_comerciales", "subsystem", column: "subid", name: "contactos_comerciales_subid_fk"
  add_foreign_key "desptlocalidad", "desptorganismo", column: "organismoid", primary_key: "organismoid", name: "desptlocalidad_organismoid_fk"
  add_foreign_key "desptorganismo", "desptprovincia", column: "provinciaid", primary_key: "provinciaid", name: "desptorganismo_provinciaid_fk"
  add_foreign_key "docindice", "ambito", primary_key: "ambitoid", name: "docindice_ambito_id_fk"
  add_foreign_key "docindice", "docindice", column: "parentid", primary_key: "catid", name: "docindice_parent_id_fk"
  add_foreign_key "docindice_materia", "docindice", column: "catid", primary_key: "catid", name: "docindice_materia_catid_fk"
  add_foreign_key "docindice_materia", "materia", column: "materiaid", name: "docindice_materia_materiaid_fk"
  add_foreign_key "docindice_settings", "docindice", column: "catid", primary_key: "catid", name: "docindice_settings_catid_fk"
  add_foreign_key "docindice_settings", "nivel_voces", column: "nivel_voces_id", name: "docindice_settings_nivel_voces_id_fk"
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
  add_foreign_key "materia_indice_root", "docindice", column: "catid", primary_key: "catid", name: "materia_indice_root_ibfk_2"
  add_foreign_key "materia_indice_root", "materia", column: "materiaid", name: "materia_indice_root_ibfk_1"
  add_foreign_key "materia_producto", "materia", column: "materiaid", name: "materia_producto_ibfk_2"
  add_foreign_key "materia_producto", "producto", column: "productoid", name: "materia_producto_ibfk_1"
  add_foreign_key "materia_seccionweb", "materia", column: "materiaid", name: "materia_seccionweb_materiaid_fk"
  add_foreign_key "materia_seccionweb", "seccionweb", column: "seccionid", name: "materia_seccionweb_seccionid_fk"
  add_foreign_key "materia_subsystem", "materia", column: "materiaid", name: "materia_subsystem_materiaid_fk"
  add_foreign_key "materia_subsystem", "subsystem", column: "subid", name: "materia_subsystem_subid_fk"
  add_foreign_key "modulo_premium_subsystem", "modulo", column: "moduloid", name: "modulo_premium_subsystem_moduloid_fk"
  add_foreign_key "modulo_premium_subsystem", "subsystem", column: "subid", name: "modulo_premium_subsystem_subid_fk"
  add_foreign_key "modulo_subsystem", "modulo", column: "moduloid", name: "modulo_subsystem_moduloid_fk"
  add_foreign_key "modulo_subsystem", "subsystem", column: "subid", name: "modulo_subsystem_subid_fk"
  add_foreign_key "novedad", "despeditorial", column: "editorialid", name: "novedad_editorialid_fk"
  add_foreign_key "novedad", "documento", column: "docid", primary_key: "docid", name: "novedad_docid_fk"
  add_foreign_key "novedad", "grupo_materia", column: "gmid", name: "novedad_gmid_fk"
  add_foreign_key "novedad", "grupo_novedades_notarios", column: "gruponovid", name: "novedad_gruponovid_fk"
  add_foreign_key "novedad", "subsystem", column: "subid", name: "novedad_subid_fk"
  add_foreign_key "novedad_video", "subsystem", column: "subid", name: "novedad_video_subid_fk"
  add_foreign_key "per_directory", "per_directory", column: "parentdirectoryid", primary_key: "directoryid", name: "per_directory_parentdirectoryid_fk"
  add_foreign_key "per_directory", "per_subscription", column: "persubscription_id", primary_key: "subscriptionid", name: "per_directory_persubscription_id_fk"
  add_foreign_key "per_directory_doc", "per_directory", column: "perdirectory_id", primary_key: "directoryid", name: "per_directory_doc_perdirectory_id_fk"
  add_foreign_key "per_directory_indexes", "per_directory", column: "perdirectory_id", primary_key: "directoryid", name: "per_directory_indexes_perdirectory_id_fk"
  add_foreign_key "per_directory_search", "per_directory", column: "perdirectory_id", primary_key: "directoryid", name: "per_directory_search_perdirectory_id_fk"
  add_foreign_key "producto_jurisdiccion", "despsjurisdiccion", column: "jurisdiccionid", name: "producto_jurisdiccion_jurisdiccion_fk"
  add_foreign_key "producto_jurisdiccion", "producto", column: "productoid", name: "producto_jurisdiccion_productoid_fk"
  add_foreign_key "producto_origen", "despsorigen", column: "origenid", name: "producto_origen_origenid_fk"
  add_foreign_key "producto_origen", "producto", column: "productoid", name: "producto_origen_productoid_fk"
  add_foreign_key "promocion", "catalogo_banner", column: "imagenid", name: "promocion_imagenid_fk"
  add_foreign_key "promocion", "subsystem", column: "subid", name: "promocion_subid_fk"
  add_foreign_key "promocion_formacion", "subsystem", column: "subid", name: "promocion_formacion_subid_fk"
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
