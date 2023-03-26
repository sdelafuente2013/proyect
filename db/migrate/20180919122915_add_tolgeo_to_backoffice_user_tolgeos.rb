class AddTolgeoToBackofficeUserTolgeos < ActiveRecord::Migration[5.1]
  def change
    add_reference :backoffice_user_tolgeos, :tolgeo, foreign_key: true
    remove_column :backoffice_user_tolgeos, :tolgeo_name, :string, null: false
    add_index :backoffice_user_tolgeos, [:tolgeo_id, :backoffice_user_id], unique: true, name: 'by_tolgeo_user'
  end
end
