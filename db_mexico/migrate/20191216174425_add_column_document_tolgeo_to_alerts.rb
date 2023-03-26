class AddColumnDocumentTolgeoToAlerts < ActiveRecord::Migration[5.1]
  def change
    add_column :alerts, :document_tolgeo, :string, null: false, default: 'mex'

    remove_index :alerts, name: 'index_alerts_app_id_document_id_alertable_id_alertable_type'
    add_index :alerts, [:app_id, :document_id, :document_tolgeo, :alertable_id, :alertable_type], unique: true, name: 'index_alerts_app_id_document_id_alertable_id_alertable_type'

  end
end
