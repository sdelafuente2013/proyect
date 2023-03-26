class AddSiteUrlToSubsystem < ActiveRecord::Migration[5.1]
  def change
    add_column :subsystem, :url, :string
  end
end
