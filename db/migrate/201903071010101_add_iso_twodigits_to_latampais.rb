class AddIsoTwodigitsToLatampais < ActiveRecord::Migration[5.1]
  def change
    add_column :desppaislatam, :codigo_iso_2digits, :string, null: true
  end
end
