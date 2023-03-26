class LopdUsersController < ApplicationController

  before_action :set_lopd_user, only: [:show, :update]
  before_action :set_lopd_app, :set_lopd_ambito, only: [:create]

  def index
    response_with_objects(Tirantid::LopdUser.search(search_params), Tirantid::LopdUser.search_count(search_params))
  end

  def show
    response_with_object(@lopd_user)
  end
  
  def create
    @lopd_user = Tirantid::LopdUser.create!(user_params.merge({:lopd_ambito => @lopd_ambito}))
    response_with_object(@lopd_user, :created)
  end
  
  def update
    @lopd_user.update(user_params)
    response_with_object(@lopd_user, :accepted)
  end

  private

  def default_search_param_keys
    super()+[:lopd_app, :lopd_ambito, :usuario, :usuarios => []]
  end

  def user_params
    encode_params(params.permit(Tirantid::LopdUser.new.attributes.keys+[:lopd_app_name, :lopd_ambito_name, :lopd_data_encoding]))
  end
  
  def set_lopd_user
    @lopd_user = Tirantid::LopdUser.find(params[:id])
  end
  
  def set_lopd_app
    @lopd_app = Tirantid::LopdApp.by_name(user_params[:lopd_app_name]).first!
  end
  
  def set_lopd_ambito
    @lopd_ambito = @lopd_app.lopd_ambitos.by_name(user_params[:lopd_ambito_name]).first!
  end
  
  def encode_params(parameters)
    should_deep_transform_from_latin_to_utf8?(parameters[:lopd_app_name], parameters[:lopd_data_encoding])?
        deep_transform_from_latin_to_utf8(parameters, parameters[:lopd_data_encoding]) : 
        parameters
  end
  
  def should_deep_transform_from_latin_to_utf8?(lopd_app,lopd_data_encoding)
    if (lopd_data_encoding.blank?)
      return  Tirantid::LopdApp::LIBRERIAS.include?(lopd_app) # Por defecto, las librerias vienen en ISO-8859-1
    else
      return "utf8" != lopd_data_encoding.gsub(/[\-\_]/,'').downcase
    end
  end

  def deep_transform_from_latin_to_utf8(paramx, params_data_encoding = 'ISO-8859-1')
    encoding = params_data_encoding.present? ? params_data_encoding : 'ISO-8859-1'
    paramx.transform_values!{ |val|
      if (val.is_a?(ActionController::Parameters) || val.is_a?(Hash))
        val = deep_transform_from_latin_to_utf8(val, encoding)
      else
        val = val.to_s.force_encoding(encoding).encode('UTF-8')
      end
      val
    }
    paramx
  end
  
end
