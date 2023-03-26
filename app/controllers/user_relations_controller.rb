class UserRelationsController < ApplicationController

  def index
    results = user_for_tolgeos
    response_with_objects(results, results.size)
  end

  protected

  def default_search_param_keys
    super()+[:cloud_user_id]
  end

  def user_for_tolgeos
    result = []
    Tolgeo.find().each do |tolgeo|
       result+=Objects.tolgeo_model_class(tolgeo,
                                         'user').by_cloudlibrary_user(search_params[:cloud_user_id] || 0)
    end
    result
  end

end
