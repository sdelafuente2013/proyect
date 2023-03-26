class AddBackofficeUserTolgeoToBackofficeUserSubsystems < ActiveRecord::Migration[5.1]
  def change
    add_reference :backoffice_user_subsystems, :backoffice_user_tolgeo, foreign_key: true
    remove_column :backoffice_user_subsystems, :tolgeo_name, :string, null: false
    remove_column :backoffice_user_subsystems, :backoffice_user_id, :integer, null: false
    add_index :backoffice_user_subsystems, [:backoffice_user_tolgeo_id, :subsystem_id], unique: true, name: 'by_tolgeo_subsystem'
  end
end
