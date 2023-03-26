class AddShowLeadPopupsFlagsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :usuario, :show_demo, :boolean, null: false, default: false
    add_column :usuario, :show_alta_personalizacion, :boolean, null: false, default: false
  end
end
