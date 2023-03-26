class AddTimestampsToBackofficeUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :backoffice_users, :creation_date
    add_timestamps :backoffice_users, null: true
  end
end
