class AddRessetPasswordColumnsToUserSubscription < ActiveRecord::Migration[5.1]
  def change
    add_column :per_subscription, :reset_password_token, :string
    add_column :per_subscription, :reset_password_sent_at, :datetime
  end
end
