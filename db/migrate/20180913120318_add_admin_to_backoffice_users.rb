class AddAdminToBackofficeUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :backoffice_users, :admin, :boolean, default: false
  end
end
