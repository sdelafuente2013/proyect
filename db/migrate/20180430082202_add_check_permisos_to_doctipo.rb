class AddCheckPermisosToDoctipo < ActiveRecord::Migration[5.1]
  def change
    add_column :doctipo, :check_permisos, :boolean, :default => true
    document_type = Esp::DocumentType.find_by(:id => 8)
    Esp::DocumentType.update(8, check_permisos: false) unless document_type.nil?
  end
end
