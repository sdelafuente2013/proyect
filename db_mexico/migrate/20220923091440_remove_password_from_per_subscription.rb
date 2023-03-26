# frozen_string_literal: true

class RemovePasswordFromPerSubscription < ActiveRecord::Migration[5.1]
  def change
    remove_column :per_subscription, :password, :string
  end
end
