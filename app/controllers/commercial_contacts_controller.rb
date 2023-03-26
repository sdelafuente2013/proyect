class CommercialContactsController < BaseController
  private

  def set_item_class
    @item_class = Objects.tolgeo_model_class(params['tolgeo'], 'commercial_contact')
  end

  def default_search_param_keys
    super()+[:subid, :origin, :email, :telefono ,:created_at, :id_usuario, :fecha_alta_start, :fecha_alta_end]
  end

  def item_params
    params.permit(@item_class.new.attributes.keys + [:lopd_privacidad, :lopd_comercial, :lopd_grupo])
  end
end

