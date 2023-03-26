class UserSubscriptionCasesController < ApplicationController
  before_action :set_user_subscription_case_class
  before_action :load_user_subscription_case_with_params, :only => [:show]
  before_action :load_user_subscription_case, :only => [:update, :destroy]

  def index
    response_with_objects(load_user_subscription_cases, total_user_subscription_cases)
  end

  def create
    user_subscription_case = create_user_subscription_case
    response_with_object(user_subscription_case, :created)
  end

  def show
    response_with_object(@user_subscription_case)
  end

  def update
    @user_subscription_case.update!(user_subscription_case_params)
    response_with_object(@user_subscription_case)
  end

  def destroy
    @user_subscription_case.destroy!
    response_with_no_content
  end

  protected
  
  def load_user_subscription_case_with_params
    # NOTE IMPORTANTE: Cambiar en las llamadas tol pasar el user_subscription_id en los update, destroy y show
    @user_subscription_case = @user_subscription_case_class.by_user_subscription_id(params[:user_subscription_id]).find(params[:id])
  end
  
  def load_user_subscription_case
    @user_subscription_case = @user_subscription_case_class.find(params[:id])
  end

  def load_user_subscription_cases
    if !params['only_total']
      @user_subscription_case_class.search(search_params)
    end
  end

  def total_user_subscription_cases
    @user_subscription_case_class.search_count(search_params)
  end

  def create_user_subscription_case
    @user_subscription_case_class.create!(user_subscription_case_params)
  end
  
  def default_search_param_keys
    super()+[:namecase,:user_subscription_id,:folderContent]
  end

  private

  def user_subscription_case_params
    # params.permit(@user_subscription_case_class.new.fields.keys)
    params.permit(["_id", "created_at", "updated_at", "namecase", "summary", "user_subscription_id", "folderContent", "downloadUrl", "downloadUrlDate", "documents" => [], "annotations" => []])
  end

  def set_user_subscription_case_class
    @user_subscription_case_class = Objects.tolgeo_model_class(params['tolgeo'], 'user_subscription_case')
  end
  
end
