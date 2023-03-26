module Search
  def default_search_param_keys
    [:q, :page, :per, :tolgeo, :sort, :order, :locale, :current_user_id, :nif,
     :cif, :not_grouped, :acceso_tablet, :iscolectivo, ids: []]
  end

  def search_params
    search_param_hash_keys = default_search_param_keys.select{|i| i.is_a?(Hash) && i.values[0].is_a?(Hash)}.map{|k| k.keys[0] }
    options = params.permit(default_search_param_keys.map{|i| i.is_a?(Hash) && search_param_hash_keys.include?(i.keys[0]) ? i.keys[0] : i}).to_h
    options.inject({}) { |h, (k, v)| options[k] = search_param_hash_keys.include?(k) && v.is_a?(String) && !v.blank? ? begin eval(v) rescue v end  : v; h }
    ActionController::Parameters.new(options).permit!
  end

  def params_with_filter_subsytem_from_backoffice_user
    subsystem_ids = []
    if search_params[:current_user_id]
      subsystem_ids = Esp::BackofficeUser.find(params[:current_user_id].to_i).subsystems_by_tolgeo(params[:tolgeo])
    end
    search_params.merge(:user_subsystem_ids => subsystem_ids)
  end
end
