class RenameTolgeoDefaultOnBackofficeUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :backoffice_users, :tolgeo_default, :tolgeo_default_id
  end
end
