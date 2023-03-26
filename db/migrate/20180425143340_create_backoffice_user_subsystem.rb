class CreateBackofficeUserSubsystem < ActiveRecord::Migration[5.1]
  def change
    create_table :backoffice_user_subsystems , options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
      t.string "tolgeo_name", null: false
      t.integer "backoffice_user_id", null: false
      t.integer "subsystem_id", null: false
    end
  end
end
