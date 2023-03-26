class AddIndexNameToTolgeos < ActiveRecord::Migration[5.1]
  def change
    add_index :tolgeos, :name, unique: true
  end
end
