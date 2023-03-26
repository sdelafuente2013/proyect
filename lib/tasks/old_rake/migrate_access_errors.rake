namespace :migrate_access_errors do
  desc "Migrar Errors de mysql a mongo de los últimos dos meses"
  task generate: :environment do
    sql = "Select tipo_error_acceso_id, usuarioid, username, descripcion, created_at, tipo_peticion from error_acceso where created_at >= '%s'" %  2.months.ago.strftime("%Y-%m-%d %H:%M:%S")
    
    items = []
    ActiveRecord::Base.connection.execute(sql).each do |mysql_error_access|
      
      items << {"tipo_error_acceso_id" => mysql_error_access[0],
                 "usuarioid" => mysql_error_access[1], 
                 "username" =>  mysql_error_access[2],
                 "descripcion" =>  mysql_error_access[3],
                 "created_at" =>  mysql_error_access[4],
                 "tipo_peticion" => mysql_error_access[5]
                }
    end  
    
    puts "INSERTING:  %s" % items.size
    Esp::AccessError.collection.insert_many(items)
    
  end
end