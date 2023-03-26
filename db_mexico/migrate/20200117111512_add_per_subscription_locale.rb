class AddPerSubscriptionLocale < ActiveRecord::Migration[5.1]
  def change
    add_column :per_subscription, :lang, :string, null: true, limit: 3
  end
end
