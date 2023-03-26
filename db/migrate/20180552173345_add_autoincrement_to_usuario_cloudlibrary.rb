class AddAutoincrementToUsuarioCloudlibrary < ActiveRecord::Migration[5.1]
  def up
    execute "ALTER TABLE `usuario_cloudlibrary` DROP FOREIGN KEY usuario_cloudlibrary_usuarioid_fk, DROP FOREIGN KEY usuario_cloudlibrary_moduloid_fk,  DROP PRIMARY KEY, ADD id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT FIRST, ADD INDEX `an_index_name_for_c1_c2` (`usuarioid`, `moduloid`)"
  end

  def down
    remove_column :usuario_cloudlibrary, :id
    remove_index :usuario_cloudlibrary, column: [:usuarioid, :moduloid]
    execute "ALTER TABLE usuario_cloudlibrary ADD PRIMARY KEY(usuarioid,moduloid);"
  end
end
