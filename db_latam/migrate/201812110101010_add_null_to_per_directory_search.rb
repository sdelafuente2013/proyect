class AddNullToPerDirectorySearch < ActiveRecord::Migration[5.1]
  def change
    change_column :per_directory_search, :is_latam, :boolean, default: false, null: true
  end
end
