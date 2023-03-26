class AddPasswordandSaltToPerPresubscription < ActiveRecord::Migration[5.1]
  def change
    add_column :per_presubscription, :password_digest, :string
    add_column :per_presubscription, :password_salt, :string
  end
end
