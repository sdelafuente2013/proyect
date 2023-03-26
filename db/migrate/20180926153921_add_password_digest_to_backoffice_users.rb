class AddPasswordDigestToBackofficeUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :backoffice_users, :password_digest, :string
    remove_column :backoffice_users, :password, :string, null: false
  end
end
