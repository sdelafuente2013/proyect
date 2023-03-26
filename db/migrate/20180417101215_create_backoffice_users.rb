class CreateBackofficeUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :backoffice_users, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
      t.string "email", null: false, unique: true
      t.string "password", null: false
      t.datetime "last_login"
      t.datetime "creation_date"
      t.integer "active", limit: 1, :default => true
    end
  end
end

