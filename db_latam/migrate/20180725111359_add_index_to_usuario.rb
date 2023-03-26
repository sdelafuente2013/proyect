class AddIndexToUsuario < ActiveRecord::Migration[5.1]
  def change
    add_index :usuario, :cloudlibrary_user
  end
end
