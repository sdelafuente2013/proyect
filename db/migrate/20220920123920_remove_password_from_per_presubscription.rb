# frozen_string_literal: true

class RemovePasswordFromPerPresubscription < ActiveRecord::Migration[5.1]
  def change
    remove_column :per_presubscription, :password, :string
  end
end
