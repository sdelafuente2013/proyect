class AddShowLeadsPopupsFlagsToSubsystems < ActiveRecord::Migration[5.1]
  def change
    add_column :subsystem, :show_demo, :boolean, null: false, default: true
    add_column :subsystem, :show_alta_personalizacion, :boolean, null: false, default: true
  end
end
