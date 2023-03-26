class AddPersonaContactoToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :usuario, :persona_contacto, :string, limit:255, null:true
    add_column :usuario, :direccion, :string, limit:500, null:true
    add_column :usuario, :poblacion, :string, limit:500, null:true
    add_column :usuario, :cp, :string, limit:20, null:true
    add_column :usuario, :telefono, :string, limit:20, null:true
    add_column :usuario, :fax, :string, limit:20, null:true
  end
end
