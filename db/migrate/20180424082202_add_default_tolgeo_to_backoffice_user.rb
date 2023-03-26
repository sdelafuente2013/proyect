class AddDefaultTolgeoToBackofficeUser < ActiveRecord::Migration[5.1]
  def change
    add_column :backoffice_users, :tolgeo_default, :string
  end
end
