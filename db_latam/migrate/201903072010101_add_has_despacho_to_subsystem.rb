class AddHasDespachoToSubsystem < ActiveRecord::Migration[5.1]
  def change
    add_column :subsystem, :has_despachos, :boolean, null: false, default: false
  end
end
