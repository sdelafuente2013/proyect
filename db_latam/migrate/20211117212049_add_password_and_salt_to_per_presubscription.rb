class AddPasswordAndSaltToPerPresubscription < ActiveRecord::Migration[5.1]
  def change
    add_column :per_presubscription, :password_digest, :string
    add_column :per_presubscription, :password_salt, :string
    add_column :per_presubscription, :password_digest_md5, :string
  end
end
