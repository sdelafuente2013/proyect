class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
      t.string :description, null: false
      t.index :description, unique: true
    end
  end
end
