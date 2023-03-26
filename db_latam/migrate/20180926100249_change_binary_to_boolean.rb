class ChangeBinaryToBoolean < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        change_column :contactos_comerciales, :iscolectivo, :boolean, default: false, null: false
        change_column :contactos_comerciales, :publicidad, :boolean, default: false, null: false
        change_column :docindice, :hoja, :boolean, default: false, null: false
        change_column :docindice, :temporalmente_nosegestionan, :boolean, default: false, null: false
        change_column :docindice_settings, :voz, :boolean, default: false, null: false
        change_column :novedad, :athome, :boolean, default: false, null: false
        change_column :novedad, :destacado, :boolean, default: false, null: false
        change_column :novedad_historico, :athome, :boolean, default: false, null: false
        change_column :novedad_historico, :destacado, :boolean, default: false, null: false
        change_column_null :per_directory_search, :is_latam, false, 0 
        change_column :per_directory_search, :is_latam, :boolean, default: false, null: false
        change_column :per_subscription, :news, :boolean, default: false, null: false
        change_column :per_subscription, :countrynews, :boolean, default: false, null: false
        change_column :servicio, :athome, :boolean, default: false, null: false
        change_column :servicio, :hide, :boolean, default: false, null: false
        change_column :tolusuarios_admin_user, :account_expired, :boolean, default: false, null: false
        change_column :tolusuarios_admin_user, :account_locked, :boolean, default: false, null: false
        change_column :tolusuarios_admin_user, :enabled, :boolean, default: false, null: false
        change_column :tolusuarios_admin_user, :password_expired, :boolean, default: false, null: false
        change_column :usuario, :iscolectivo, :boolean, default: false, null: false
        change_column :usuario, :isdemo, :boolean, default: false, null: false
      end

      dir.down do
        change_column :contactos_comerciales, :iscolectivo, :binary, limit: 1, default: 0, null: false
        change_column :contactos_comerciales, :publicidad, :binary, limit: 1, default: 0, null: false
        change_column :docindice, :hoja, :binary, limit: 1, default: 0, null: false
        change_column :docindice, :temporalmente_nosegestionan, :binary, limit: 1, default: 0, null: false
        change_column :docindice_settings, :voz, :binary, limit: 1, default: 0, null: false
        change_column :novedad, :athome, :binary, limit: 1, default: 0, null: false
        change_column :novedad, :destacado, :binary, limit: 1, default: 0, null: false
        change_column :novedad_historico, :athome, :binary, limit: 1, default: 0, null: false
        change_column :novedad_historico, :destacado, :binary, limit: 1, default: 0, null: false
        change_column :per_directory_search, :is_latam, :binary, limit: 1, default: 0, null: false
        change_column :per_subscription, :news, :binary, limit: 1, default: 0, null: false
        change_column :per_subscription, :countrynews, :binary, limit: 1, default: 0, null: false
        change_column :servicio, :athome, :binary, limit: 1, default: 0, null: false
        change_column :servicio, :hide, :binary, limit: 1, default: 0, null: false
        change_column :tolusuarios_admin_user, :account_expired, :binary, limit: 1, default: 0, null: false
        change_column :tolusuarios_admin_user, :account_locked, :binary, limit: 1, default: 0, null: false
        change_column :tolusuarios_admin_user, :enabled, :binary, limit: 1, default: 0, null: false
        change_column :tolusuarios_admin_user, :password_expired, :binary, limit: 1, default: 0, null: false
        change_column :usuario, :iscolectivo, :binary, limit: 1, default: 0, null: false
        change_column :usuario, :isdemo, :binary, limit: 1, default: 0, null: false
      end
    end
  end
end
