class CreateGmUsuario < ActiveRecord::Migration[5.1]
  def change
    create_table :gm_usuario do |t|
      t.bigint "usuarioid", null: false
      t.integer "gmid", null: false
    end
  end
end