module TestsDiagnosticConcern

  def prueba_db_esp_frontend
    prueba_db Esp::Ambit, :nombre
  end
  
  def prueba_db_mex_frontend
    prueba_db Mex::Ambit, :nombre
  end

  def prueba_db_latam_frontend
    prueba_db Latam::Ambit, :nombre
  end

  def prueba_db_lopd
    prueba_db Tirantid::LopdAmbito, :nombre
  end

  def database_diagnostic
    { esp_frontend: prueba_db_esp_frontend,
      mex_frontend: prueba_db_mex_frontend,
      latam_frontend: prueba_db_latam_frontend,
      lopd: prueba_db_lopd
    }
  end

  def prueba_db(db_class,modify_attribute_string)
    logger.info "database_diagnostic #{db_class} BEGIN #{Time.now}"

    to_do_the_test do
      3.times do
          db_class.limit(1+rand(5)).order("RAND()").to_a
      end

      db_class.transaction do
        u = db_class.first
        u.send("#{modify_attribute_string.to_s}=".to_sym,'diagnostic test')
        u.save
        raise ActiveRecord::Rollback
      end
    end

    logger.info "database_diagnostic #{db_class} END #{Time.now}"
  end


  def mongo_diagnostic
    result={}
    Mongoid.clients.
    each do |client_name, client_options|
      logger.info "database_diagnostic #{client_name} BEGIN #{Time.now}"
      result[client_name] = to_do_the_test do
        client = Mongoid.client(client_name)
        client.database['xt_api_diagnostic'].insert_one({ name: client_name })
        client.database['xt_api_diagnostic'].find({ name: client_name })
        client.database['xt_api_diagnostic'].find_one_and_delete({ name: client_name })
      end
      logger.info "database_diagnostic #{client_name} END #{Time.now}"
    end
    result
  end

  def to_do_the_test
    begin
      yield
      "OK"
    rescue => e
      "Error: #{e}"
    end
  end

end
