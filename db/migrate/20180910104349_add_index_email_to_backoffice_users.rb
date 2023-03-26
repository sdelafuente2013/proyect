class AddIndexEmailToBackofficeUsers < ActiveRecord::Migration[5.1]
  def change
    add_index :backoffice_users, :email, unique: true
  end
end
