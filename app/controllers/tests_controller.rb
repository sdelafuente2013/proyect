class TestsController < ApplicationController
  include TestsDiagnosticConcern

  def index
    _mongo_status = (params[:mongo].blank? or params[:mongo].to_bool) ? mongo_status.with_indifferent_access : {}
    _database_status = (params[:database].blank? or params[:database].to_bool) ? database_status.with_indifferent_access : {}

    _mongo_connectable = _mongo_status.all?{|client_name,status| status['connectable?']}
    _database_connectable = _database_status.all?{|client_name,status| status['connectable?']}

    result = { message: 'Hello dani V1', env: Rails.env,
      database: {'connectable?': _database_connectable},
      mongo:    {'connectable?': _mongo_connectable}
    }.with_indifferent_access

    if not params[:short].present?
      result[:database][:connections]=_database_status
      result[:mongo][:connections]=_mongo_status
    end

    respond_with( result )
  end

  def diagnostic
    _database_diagnostic = (params[:database].blank? or params[:database].to_bool) ? database_diagnostic : {}
    _mongo_diagnostic = (params[:mongo].blank? or params[:mongo].to_bool) ? mongo_diagnostic : {}
    respond_with( { message: 'Tests en serio', env: Rails.env,
      database: _database_diagnostic,
      mongo:  _mongo_diagnostic} )
  end

  private

  def tests
    _tests = params[:tests].presence || 'all'
    Settings.devops[:tests][_tests.to_sym]
  end

  def mongo_client_test_enabled?(client_name)
    [tests[:read][:mongo], tests[:write][:mongo]].flatten.compact.include?(client_name.to_s)
  end

  def database_client_test_enabled?(connection_name)
    [tests[:read][:database], tests[:write][:database]].flatten.compact.include?(connection_name.to_s)
  end

  def respond_with(data)
    render :json => data
  end

  def mongo_status
    result={}
    Mongoid.clients.each do |client_name, client_options|
      if mongo_client_test_enabled?(client_name)
        logger.info "mongo_status #{client_name} BEGIN #{Time.now}"

        client = Mongoid.client(client_name)
        servers = client.cluster.servers.map{|s| {'server':s.address, 'connectable?':s.connectable? }}
        connectable = client.cluster.servers.any?{|s| s.connectable? }
        has_readable_server = client.cluster.has_readable_server?(Mongo::ServerSelector.get(mode: :secondary)) || client.cluster.has_readable_server?(Mongo::ServerSelector.get(mode: :primary))
        may_has_writable_server = tests[:write][:mongo].blank? ||
                              !tests[:write][:mongo].include?(client_name) ||
                              (tests[:write][:mongo].include?(client_name) && client.cluster.has_writable_server?)

        connectable = connectable && has_readable_server && may_has_writable_server
        result[client_name]={name:client_name, servers: servers,
          'connectable?': connectable,
          has_readable_server:has_readable_server
        }.with_indifferent_access
        result[client_name][:options]=client_options if params[:options].present?
        result[client_name][:has_writable_server]=may_has_writable_server if !tests[:write][:mongo].blank? && tests[:write][:mongo].include?(client_name)
        logger.info "mongo_status #{client_name} END #{Time.now}"
      end
    end
    result
  end

  def database_status
    Rails.application.eager_load! unless Rails.configuration.cache_classes
    all_models = ActiveRecord::Base.descendants
    connections = all_models.map(&:connection_specification_name).uniq.
    inject({}) do |result,connection_name|
      result[connection_name]={} if database_client_test_enabled?(connection_name)
      result
    end

    all_models.each do |model|
      connection_name = model.connection_specification_name
      if !connections[connection_name].nil? && connections[connection_name].try(:[],'connectable?').nil?
        logger.info "database_status #{connection_name} BEGIN #{Time.now}"
        servers = model.connection_config[:makara]['connections']
        connectable = test_database_connection(model)
        has_readable_server = connectable
        may_has_writable_server = tests[:write][:database].blank? ||
                              !tests[:write][:database].include?(connection_name) ||
                              (tests[:write][:database].include?(connection_name) && test_database_connection_write(model))

        connectable = connectable && has_readable_server && may_has_writable_server
        connections[connection_name] = { name:connection_name, servers: servers ,
          'connectable?': connectable, has_readable_server:has_readable_server
        }.with_indifferent_access
        connections[connection_name][:options]=model.connection_config if params[:options].present?
        connections[connection_name][:has_writable_server]=may_has_writable_server if !tests[:write][:database].blank? && tests[:write][:database].include?(connection_name)
        logger.info "database_status #{connection_name} END #{Time.now}"
      end
    end

    connections
  end

  def test_database_connection(model)
    begin
      mysql_config = model.connection_config.merge(:read_timeout => 1, :write_timeout => 1, :connect_timeout => 1)
      mysq_client = Mysql2::Client.new(model.connection_config)
      result = mysq_client.query('SELECT 1=1 as v')
      v1 = result.first['v']
      mysq_client.close
      v1 == 1
    rescue
      false
    end
  end

  def test_database_connection_write(model)
    begin
      model.connection_pool.with_connection do |conn|
        query_cache_enabled = conn.query_cache_enabled
        if query_cache_enabled
          conn.disable_query_cache!
          conn.clear_query_cache
        end
        conn.stick_to_master!(true)
        v1 = conn.select_one('SELECT 1=1 as v')['v']
        conn.enable_query_cache! if query_cache_enabled
        v1 == 1
      end
    rescue
      false
    end
  end

end
