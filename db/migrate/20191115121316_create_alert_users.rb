class CreateAlertUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :alert_users do |t|
      t.string 'app_id', null: false
      t.string 'email', null: false
      t.datetime 'created_at'
    end
    add_index :alert_users, [:app_id, :email], unique: true
  end
end
