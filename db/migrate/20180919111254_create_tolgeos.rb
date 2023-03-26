class CreateTolgeos < ActiveRecord::Migration[5.1]
  def change
    create_table :tolgeos, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
      t.string :name, null: false
      t.string :description, null: false
    end
  end
end
