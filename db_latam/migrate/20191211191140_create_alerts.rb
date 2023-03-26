class CreateAlerts < ActiveRecord::Migration[5.1]
  def change
    create_table :alerts do |t|
      t.string 'app_id', null: false
      t.bigint 'document_id', null: false
      t.string 'document_tolgeo', null: false
      t.datetime 'alert_date'
      t.bigint 'alertable_id', null: false
      t.timestamps
      t.string 'alertable_type', default: 'Latam::AlertUser'
    end
    add_index :alerts, [:app_id, :document_id, :document_tolgeo, :alertable_id, :alertable_type], unique: true, name: 'index_alerts_app_id_document_id_alertable_id_alertable_type'
    add_index :alerts, [:alertable_id, :alertable_type]
  end
end