class UserStatsController < ApplicationController

  before_action :set_user_stat_class

  def index
    response_with_objects(@user_stat_class.search(params_with_filter_subsytem_from_backoffice_user),
                          count_results)
  end

  protected

  def default_search_param_keys
    super()+[:user_id, :fecha_start, :fecha_end, :num_sessions, :num_documents, :period, :fecha_alta_start, :fecha_alta_end, :subid, :tipousuariogrupoid, :isactivo]
  end

  def count_results
      @user_stat_class.from(@user_stat_class.search_scopes(search_params)).count()

  end

  private

  def set_user_stat_class
    @user_stat_class = Objects.tolgeo_model_class(params['tolgeo'], 'user_stat')
  end

end
