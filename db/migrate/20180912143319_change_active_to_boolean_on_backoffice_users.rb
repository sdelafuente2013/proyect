class ChangeActiveToBooleanOnBackofficeUsers < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        change_column :backoffice_users, :active, :boolean, default: true
      end

      dir.down do
        change_column :backoffice_users, :active, :integer, limit: 1, default: 1
      end
    end
  end
end
