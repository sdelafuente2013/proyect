module TabletPermissionsHelper

  class << self
     
    def update(changes, user)
      return unless changes.key?(:access_type_tablet)

      access_type_tablet_id = changes[:access_type_tablet].id
      allow_access_tablet_to_user_subscriptions(user) if allow_all?(access_type_tablet_id)
      disable_access_tablet_to_user_subscriptions(user) if disable_all?(access_type_tablet_id)
      allow_access_tablet_to_domain_user_subscriptions(user) if allow_by_domain?(access_type_tablet_id)
    end

    def update_attributes(attributes, user)
      access_type = user.tipoaccesotabletid

      add_access_tablet(attributes) if allow_all?(access_type)
      remove_access_tablet(attributes) if disable_all?(access_type)
      set_access_tablet_by_domain(attributes, user) if allow_by_domain?(access_type)
    end

    private
    
    def allow_access_tablet_to_domain_user_subscriptions(user)
      user.user_subscriptions.each do |subscription|
        is_allowed = domain_access_tablet_allowed?(subscription)

        subscription.update_attributes(acceso_tablet: is_allowed)
      end
    end

    def domain_access_tablet_allowed?(subscription)
      domain_list(subscription.user).any? do |domain|
        email = subscription.perusuid

        email.include?(domain)
      end
    end

    def domain_list(user)
      user.dominios.gsub(' ', '').split(',')
    end

    def disable_access_tablet_to_user_subscriptions(user)
      update_user_subscriptions_access_tablet(user, false)
    end

    def allow_access_tablet_to_user_subscriptions(user)
      update_user_subscriptions_access_tablet(user, true)
    end

    def update_user_subscriptions_access_tablet(user, value)
      user.user_subscriptions.update_all(acceso_tablet: value)
    end

    def add_access_tablet(attributes)
      attributes.merge!('acceso_tablet' => true)
      attributes.merge!('fecha_alta_tablet' => Time.now)
    end

    def remove_access_tablet(attributes)
      attributes.merge!('acceso_tablet' => false)
      attributes.merge!('fecha_alta_tablet' => nil)
    end

    def set_access_tablet_by_domain(attributes, user)
      remove_access_tablet(attributes)

      domains = user_domains(user)
      is_allowed = domains.any? { |domain| attributes[:perusuid].include?(domain) }

      add_access_tablet(attributes) if is_allowed
    end

    def user_domains(user)
      domains = user.dominios || ''
      domains.gsub(' ', '').split(',')
    end

    def disable_all?(access_type)
      access_type == 1
    end

    def allow_all?(access_type)
      access_type == 2
    end

    def allow_by_domain?(access_type)
      access_type == 3
    end
  end
    
end
