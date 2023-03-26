class CreateDeletedUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :deleted_users, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
      t.string "username", null: false
      t.string "password", null: false
      t.integer "userid", null: false
      t.integer "subid", null: false
      t.text    "comentario", null: true
      t.datetime "fechaalta", null: false
      t.datetime "fechaborrado", null: false
      t.integer "backoffice_user_id", null: false
      t.string "backoffice_user_name", null: false
    end
    
    add_index :deleted_users, :fechaborrado, order: :desc
  end
end

