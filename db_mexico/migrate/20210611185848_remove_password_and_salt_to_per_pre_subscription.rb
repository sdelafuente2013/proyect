class RemovePasswordAndSaltToPerPreSubscription < ActiveRecord::Migration[5.1]
  def change
    change_column_null :per_presubscription, :password, true
    remove_column :per_presubscription, :password_salt
    remove_column :per_presubscription, :password_digest

  end
end
