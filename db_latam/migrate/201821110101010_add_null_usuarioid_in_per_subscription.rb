class AddNullUsuarioidInPerSubscription < ActiveRecord::Migration[5.1]
  def change
    change_column :per_subscription, :usuarioid, :integer, null: true
  end
end
