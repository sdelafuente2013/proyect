# frozen_string_literal: true

class AddKeyToModulo < ActiveRecord::Migration[5.1]
  def change
    add_column :modulo, :key, :string
  end
end
