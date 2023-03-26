class DropBackofficeUserControllers < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        drop_table :backoffice_user_controllers
      end

      dir.down do
        create_table :backoffice_user_controllers, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
          t.string "controller_name", null: false
          t.integer "backoffice_user_id", null: false
        end
      end
    end
  end
end
