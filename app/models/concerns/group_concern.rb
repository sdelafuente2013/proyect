module GroupConcern
  extend ActiveSupport::Concern

  included do
    include Searchable
    self.table_name = 'grupo'
     
    ATTRS_TO_GROUP_UPDATE = ["maxconexiones", "permisos", "tipoaccesoid", 
                             "tipousuariogrupoid", "imagen", "isdemo", 
                             "comentario", "maxconexiones", "datelimit", "url_origen",]
     
    validates :descripcion, :tipoid, presence: true
    searchable_by :descripcion

    has_many :users, :foreign_key => 'grupoid', dependent: :nullify

    scope :by_is_active, lambda { |active|
      active.blank? ? all : active == 'true' ?
                  where("exists (select id from usuario u where u.grupoid=grupo.id and (maxconexiones > 0 and (datelimit is null or datelimit > now())))").distinct() :
                  where("not exists (select id from usuario u where u.grupoid=grupo.id and (maxconexiones > 0 and (datelimit is null or datelimit > now())))").distinct()
    }

    scope :by_popup_demo, lambda { |show_demo|
      show_demo.blank? ? all : where('show_demo =  ?', show_demo.to_s == 'true')
    }
    
    def user_model_with_group_params
      
      total_users = self.users.count
      return Objects.tolgeo_model_class(self.tolgeo, 'user').new(:id => self.id) if total_users == 0
      first_user = self.users.first
     
      attrs = first_user.attributes.select {|i,v| ATTRS_TO_GROUP_UPDATE.include?(i) and !v.nil?}.select {|k,v| self.users.group(k).count.keys.size == 1 }
    
      modulos_ids = self.users.joins(:modulos).includes(:modulos).group("modulo.id").count.select {|k,v| v == total_users}.keys
      
      subjects_ids = self.users.joins(:subjects).includes(:subjects).group("materiaid").count.select {|k,v| v == total_users}.keys
      
      products_ids = self.users.joins(:products).includes(:products).group("productoid").count.select {|k,v| v == total_users}.keys
    
     first_user.class.new(attrs.merge(:grupoid => self.id, :modulo_ids => modulos_ids, :subject_ids => subjects_ids, :product_ids => products_ids))

    end

    def destroy_with_users(backoffice_user)
      destroy_group_users(backoffice_user)
      self.destroy
    end

    def to_json(options = {})
      self.as_json(options)
    end

    def as_json(options = {})
      attrs = super options
      attrs[:is_active] = self.is_active?
      attrs
    end

    def tolgeo
      self.class.name.deconstantize.downcase
    end

    def is_active?
      self.users.merge(("%s::User" % tolgeo.capitalize).constantize.by_is_active("true")).exists?
    end
    
    def auth_external?
      self.authtype == 1
    end

    def sent_email_users(locale='es')
      self.users.each do |user|
        user.class.send_welcome_email(user, locale, ENV['DEFAULT_CC_EMAIL_ATENCION_CLIENTE_MASSIVE'])
      end
      true
    end

    def update_users(params)
      changes=params.to_h.reject{|k,v| k == "id"}
      changes_many_keys = ["userIps_attributes", "subject_ids", "modulo_ids", "product_ids"]
      changes_model = changes.reject {|k,v| changes_many_keys.include?(k) }
      changes_many = changes.reject {|k,v| !changes_many_keys.include?(k) }

      begin
        ApplicationRecord.transaction do

          self.users.update_all(changes_model) unless changes_model.empty?

          #unless changes_many.empty?

            user_ids = self.users.pluck(:id)

            unless user_ids.empty?

              user_class=Objects.tolgeo_model_class(self.tolgeo, 'user')

              user_class.insert_user_products(changes_many, user_ids, true)
              user_class.insert_user_modulos(changes_many, user_ids, true)
              user_class.insert_user_subjects(changes_many, user_ids, true)
              user_class.insert_user_ips(changes_many, user_ids, true)

            end
          #end
        end
        return true
      rescue ActiveRecord::RecordInvalid
        return false
      end
    end
    
    def move_all_users_to_group(group_destination)
      self.users.update_all(:grupoid =>group_destination.id)
    end  
    
    def self.search_scopes(params)
      by_ids(params[:ids]).
      autocomplete(params[:q]).
      by_is_active(params[:isactivo]).
      by_popup_demo(params[:show_demo])
    end

    private

    def destroy_group_users(backoffice_user)
      group_users.each do |user|
        user.backoffice_user=backoffice_user
        user.destroy
      end
    end

    def group_users
      users = Objects.tolgeo_model_class(tolgeo, 'user')

      users.where(group: self.id)
    end
  end
end

