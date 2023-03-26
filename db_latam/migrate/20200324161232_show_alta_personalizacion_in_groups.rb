class ShowAltaPersonalizacionInGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :grupo, :show_alta_personalizacion, :boolean, null: false, default: false
  end
end
