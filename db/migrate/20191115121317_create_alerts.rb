class CreateAlerts < ActiveRecord::Migration[5.1]
  def change
    create_table :alerts do |t|
      t.string 'app_id', null: false
      t.bigint 'document_id', null: false
      t.datetime 'alert_date'
      t.references :alert_user, foreign_key: true, null: false
      t.timestamps
    end
    add_index :alerts, [:app_id, :document_id, :alert_user_id], unique: true

  end
end
