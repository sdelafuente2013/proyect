class ShowDemoPopupInGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :grupo, :show_demo, :boolean, null: false, default: false
  end
end
