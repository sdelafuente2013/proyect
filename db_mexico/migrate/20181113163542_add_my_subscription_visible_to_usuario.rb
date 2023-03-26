class AddMySubscriptionVisibleToUsuario < ActiveRecord::Migration[5.1]
  def change
    add_column :usuario, :my_subscription_visible, :boolean, null: false, default: true
  end
end
