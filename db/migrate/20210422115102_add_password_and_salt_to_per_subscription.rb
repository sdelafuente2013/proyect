class AddPasswordAndSaltToPerSubscription < ActiveRecord::Migration[5.1]
  def change
    add_column :per_subscription, :password_digest, :string
    add_column :per_subscription, :password_salt, :string
  end
end
