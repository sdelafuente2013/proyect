class AddIndependentOfficesToUsuario < ActiveRecord::Migration[5.1]
  def change
    add_column :usuario, :independent_offices, :boolean, null: false, default: false
  end
end
