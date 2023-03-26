class AddConfirmationTokenToPerPresubscription < ActiveRecord::Migration[5.1]
  def change
    add_column :per_presubscription, :confirmation_token, :string
  end
end
