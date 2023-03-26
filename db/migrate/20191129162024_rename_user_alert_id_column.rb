class RenameUserAlertIdColumn < ActiveRecord::Migration[5.1]
  def change
    #remove_foreign_key :alerts, :alert_users
    remove_index :alerts, name: :index_alerts_on_app_id_and_document_id_and_alert_user_id

    rename_column :alerts, :alert_user_id, :alertable_id
    remove_foreign_key :alerts, column: :alertable_id

    add_column :alerts, :alertable_type, :string, default: 'Esp::AlertUser'

    add_index :alerts, [:app_id, :document_id, :alertable_id, :alertable_type], unique: true, name: 'index_alerts_app_id_document_id_alertable_id_alertable_type'
    add_index :alerts, [:alertable_id, :alertable_type]
  end
end
