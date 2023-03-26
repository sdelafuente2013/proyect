class AddCloudlibraryUserToUsuario < ActiveRecord::Migration[5.1]
  def change
    add_column :usuario, :cloudlibrary_user, :integer
  end
end
