class ChangeTolgeoDefaultToIntegerOnBackofficeUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :backoffice_users, :tolgeo_default, :string
    add_column :backoffice_users, :tolgeo_default, :integer, default: 0
  end
end
