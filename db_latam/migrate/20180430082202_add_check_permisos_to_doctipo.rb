class AddCheckPermisosToDoctipo < ActiveRecord::Migration[5.1]
  def change
    add_column :doctipo, :check_permisos, :boolean, :default => true
  end
end
