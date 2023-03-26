module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def json_error_response(errors=[], status =  :unprocessable_entity, code=nil)
    response = {}
    unless errors.blank?
      if (errors.is_a? Array)
        response["message"] = errors.join(",")
      elsif (errors.is_a? Exception || errors.try(:message))
        response["message"] = errors.message
      else
        response["message"] = errors.join(",")

      end
      if code
        response["tirant_code"] = code
      end
    end

    json_response(response, status)
  end

  def json_internal_error_response(errors=[], status =  :unprocessable_entity, code=nil)
    # rlogger.error "Responding internal error#{code}, errors #{errors}"
    json_error_response(errors, status, code)
  end

  def response_with_objects(objects, total = 0)
    response = { resource: '', objects: objects, total: total }
    render json: response.as_json({ scope: params[:scope] }), status: :ok
  end

  def response_with_object(object, status = :ok)
    response = {object: object.as_json({ scope: 'detail' }) }
    response.merge!(resource: object['id'].is_a?(Integer) ? object[:id] : object[:id].to_s)
    render json: response, status: status
  end

  def response_with_no_content
    head :no_content
  end
end
