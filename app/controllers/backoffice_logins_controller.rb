class BackofficeLoginsController < ApplicationController
  before_action :set_user_class

  def create
    user = Esp::BackofficeUser.find_by(email: user_params[:email])
    unless user.nil? || !user.authenticate(user_params[:password])
      if user.active?
        last_login = user.last_login
        user.update(:last_login => Time.current)
        user.password = nil
        user.last_login=last_login
        response_with_object(user, :created)
      else
        json_response({ message: "Este Usuario ha sido desactivado" }, :unauthorized)
      end
    else
      json_response({ message: "Usuario o password incorrecto"}, :unauthorized)
    end  
  end
    
  private
  
  def user_params
    params.permit(["email", "password"])
  end

  def set_user_class
    # NOTE Solo esta en una base de datos los usuarios de backoffice unificados (Spain)
    @user_class = Esp::BackofficeUser 
  end
end
