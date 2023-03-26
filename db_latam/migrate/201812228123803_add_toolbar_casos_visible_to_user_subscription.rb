class AddToolbarCasosVisibleToUserSubscription < ActiveRecord::Migration[5.1]
  def change
    add_column :per_subscription, :toolbar_casos_visible, :boolean, null: false, default: true
  end
end
