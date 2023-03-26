class UserPresubscriptionsController < ApplicationController
  before_action :set_user_presubscription_class

  def index
    response_with_objects(load_user_presubscriptions, total_user_presubscriptions)
  end

  def create
    response_with_object(create_user_presubscription, :created)
  end

  protected

  def default_search_param_keys
    super()+[:perusuid,:usuarioid,:email]
  end

  def load_user_presubscriptions
    @user_presubscription_class.search(params_with_filter_subsytem_from_backoffice_user)
  end

  def total_user_presubscriptions
    @user_presubscription_class.search_count(params_with_filter_subsytem_from_backoffice_user)
  end

  def create_user_presubscription
    @user_presubscription_class.create(user_presubscription_params)
  end

  private

  def user_presubscription_params
    params.permit(
      @user_presubscription_class.new.attributes.keys +
      %i[lopd_grupo lopd_comercial lopd_privacidad password]
    )
  end

  def set_user_presubscription_class
    @user_presubscription_class = Objects.tolgeo_model_class(params['tolgeo'], 'user_presubscription')
  end

end
