class PerSubscriptionPasswordAllowNil < ActiveRecord::Migration[5.1]
  def change
    change_column_null :per_subscription, :password, true
  end
end
