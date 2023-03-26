class CreateBackofficeUserRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :backoffice_user_roles, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
      t.references :backoffice_user, foreign_key: true
      t.references :role, foreign_key: true

      t.index [:backoffice_user_id, :role_id], unique: true, name: 'by_backoffice_user_role'
    end
  end
end
