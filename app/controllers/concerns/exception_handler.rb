module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from Exception::Login do |e|
      logger.error e
      json_response({ message: e.message, code: e.code }, :unauthorized)
    end
    
    rescue_from ActiveRecord::RecordNotFound do |e|
      logger.error e
      json_response({ message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      logger.error e
      json_response({ message: e.message }, :unprocessable_entity)
    end

    rescue_from ActiveRecord::RecordNotSaved do |e|
      logger.error e
      json_response({ message: e.record.errors.full_messages.join(", ") }, :unprocessable_entity)
    end

    rescue_from ActiveRecord::RecordNotUnique do |e|
      logger.error e
      json_response({ message: "Record not unique" }, :unprocessable_entity)
    end

    rescue_from ActionController::ParameterMissing do |e|
      logger.error e
      json_response({ message: e.message }, :unprocessable_entity)
    end

    rescue_from Mongoid::Errors::DocumentNotFound do |e|
      logger.error e
      json_response({ message: "Document(s) not found. %s " % e.summary }, :not_found)
    end

    rescue_from Mongoid::Errors::Validations do |e|
      logger.error e
      json_response({ message: e.summary }, :unprocessable_entity)
    end

    rescue_from Mongo::Error::NoServerAvailable do |e|
      response = json_internal_error_response(e, :unprocessable_entity, XTBaseClient::TirantCodeError::MONGO_EXCEPTION )
    end
    
    rescue_from Mongoid::Errors::InvalidFind do |e|
      json_response({ message: e.summary }, :unprocessable_entity)
    end  

    rescue_from Mysql2::Error do |e|
      logger.error e
      json_response({ message: e.message }, :unprocessable_entity)
    end

    rescue_from Makara::Errors::NoConnectionsAvailable do |e|
      response = json_internal_error_response(e, :unprocessable_entity, XTBaseClient::TirantCodeError::MYSQL_EXCEPTION )
    end
  end
end
