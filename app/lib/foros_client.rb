require 'rest-client'

module Foros
  module Client
    HTTP_OK = 200 unless const_defined?(:HTTP_OK)

    def ping
      send_request('ping')
    end

    def send_request(method, max_retries=configured_retries, wait_time=configured_wait_time)
      return false unless self.valid?
      uri = build_uri_for(method)
      self.errores=[]
      resource = {'code' => 400, 'error': nil}

      num_retries=0
      while (num_retries < max_retries && resource['code'] != HTTP_OK)
        begin
           response = RestClient.get(uri)
           resource['code'] = HTTP_OK
           if resource['code'] != HTTP_OK
             resource['error'] = response.to_str
             sleep wait_time
             num_retries+=1
           end
        rescue Errno::ECONNREFUSED, RestClient::Exception => response
          resource['error'] = response.http_code == 503 ? "FOROS ERROR %s" % response.response.body.to_str : "connection refused foros" 
          sleep wait_time
          num_retries+=1
        end
      end

      self.errores << resource['error'] if resource["code"] != HTTP_OK && !resource['error'].nil?
      return self.errores.empty?
    end

    def build_uri_for(endpoint)

      if endpoint == "create"
        request_uri("crea_usuario.php", self.attributes_filled)
      elsif endpoint == "update"
        request_uri("modifica_usuario.php", self.attributes_filled)
      elsif endpoint == "destroy"
        request_uri("borra_usuario.php", "&user_name=%s" % self.user_name)
      elsif endpoint == "create_group"
        request_uri("crea_grupo.php", "&user_group=%s&permis=%s" % [self.user_group, self.permis])
      elsif endpoint == "update_group"
        request_uri("modifica_grupo.php",
                    "&group_name=%s&new_group_name=%s" % [self.group_name, self.new_group_name])
      elsif endpoint == "destroy_group"
        request_uri("borra_grupo.php",
                    "&user_group=%s%s" % [self.user_group,
                                          self.disable_users.nil? ? '' :
                                          "&disable_users=%s" % self.disable_users])
      elsif endpoint == "move_group"
        request_uri("grupo_mueve_a_grupos.php",
                    "&user_group=%s&user_groups=%s&user_style=%s" % [self.user_group,
                                                                     self.user_groups,
                                                                     self.user_style])
      else
        # ping
        self.base_url
      end
    end

    def base_url
      ENV['XT_API_BASE_FOROS'] || 'http://foros.tirant.net'
    end

    def sec_pass
       ENV['XT_API_BASE_FOROS_PASS'] || 'medaigual'
    end

    def request_uri(path="", query_string="")
      query_string = (!query_string.start_with?("&") ? "&%s" : "%s")  % query_string
      "%s/%s?sec_pass=%s%s" % [self.base_url, path, self.sec_pass, query_string ]
    end

    def attributes_filled
      self.attributes.select {|i,v| !v.nil?}.map{|k,v| "%s=%s" % [k, v] }.join("&")
    end

    private

    def configured_retries
      RETRIES['times']
    end

    def configured_wait_time
      RETRIES['wait']
    end
  end
end
