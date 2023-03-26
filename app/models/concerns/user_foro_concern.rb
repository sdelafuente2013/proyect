# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
module UserForoConcern
  extend ActiveSupport::Concern
  FAKE_SECRET = 'fake_secret'

  included do
    def create_foro
      foro_perform(foro_to_create, 'create')
    end

    def destroy_foro
      foro_perform(foro_to_destroy, 'destroy')
    end

    def update_foro
      foros = foro_to_update
      foros.each do |item|
        foro_perform(item[:foro], item[:op])
      end
    end

    protected

    def foro_perform(foro, method)
      return if foro.nil?

      return if foro.send(method)

      foro.errores.each do |e|
        errors[:base] << e
      end
      raise ActiveRecord::RecordInvalid, self
    end

    def foro_to_update
      foros = []
      return foros unless allowed_subsystem?

      if consultoria_colectivo_unchanged?
        foro = consultoria_and_colectivo_unchanged
        foros << { foro: foro, op: 'update' } unless foro.nil?
      # ha cambiado consultoria
      elsif consultoria_changed?
        foros = foros_to_consultoria_change
      elsif saved_change_to_attribute?(:iscolectivo)
        foros = foros_to_colectivo_change
      end

      foros
    end

    def consultoria_colectivo_unchanged?
      has_consultoria? &&
        (has_consultoria_before.nil? or has_consultoria_before == has_consultoria?) &&
        !saved_change_to_attribute?(:iscolectivo)
    end

    def foro_to_create
      return unless allowed_subsystem? && has_consultoria?

      if iscolectivo
        return tolgeo_group_foro_class.new(
          user_group: username_group_prefixed,
          permis: "c#{subid_permisos}"
        )
      end

      tolgeo_foro_class.new(
        user_name: username_subid_collective_prefixed,
        user_email: email,
        user_pass: password,
        user_groups: "c#{subid_permisos}",
        user_style: subid_styles
      )
    end

    def foro_to_destroy
      return unless allowed_subsystem? && has_consultoria?

      if iscolectivo
        return tolgeo_group_foro_class.new(
          user_group: username_group_prefixed,
          disable_users: 1
        )
      end

      tolgeo_foro_class.new(user_name: username_subid_collective_prefixed)
    end

    def consultoria_and_colectivo_unchanged
      return unless has_consultoria?

      # Si el usuario tiene consultoria y es colectivo antes y ahora
      if iscolectivo && saved_change_to_attribute?(:username)
        return tolgeo_group_foro_class.new(
          group_name: "#{prefix_grupo}#{username_before_last_save}",
          new_group_name: username_group_prefixed
        )
      end

      # Si el usuario tiene consultoria y no es colectivo antes y ahora
      attrs = {}
      user_name = username_subid_collective_prefixed

      if saved_change_to_attribute?(:username)
        attrs[:user_name] = "C#{subid_prefix}#{username_before_last_save}"
        attrs[:new_user_name] = user_name
      end

      if saved_change_to_attribute?(:password)
        attrs[:user_name] = user_name unless attrs.key?('user_name')
        attrs[:user_pass] = password
      end

      if saved_change_to_attribute?(:email)
        attrs[:user_name] = user_name unless attrs.key?('user_name')
        attrs[:user_email] = email
      end

      return tolgeo_foro_class.new(attrs) if attrs.present?
    end

    def foros_to_consultoria_change
      foros_op = []

      if has_consultoria_before
        # pillar lo que estaba marcado antes en is_colectivo
        is_colectivo = if saved_change_to_attribute?(:iscolectivo)
                         iscolectivo_before_last_save
                       else
                         iscolectivo
                       end
        if is_colectivo
          # El usuario pasa de Consultoria/Colectivo a No Consultoria
          foros_op << {
            foro: tolgeo_group_foro_class.new(
              user_group: "#{prefix_grupo}#{username}",
              user_groups: subid_permisos,
              user_style: subid_styles
            ),
            op: 'move'
          }
          foros_op << {
            foro: tolgeo_group_foro_class.new(
              user_group: username_group_prefixed
            ),
            op: 'destroy'
          }
        else
          # El usuario pasa de Consultoria/No colectivo a No Consultoria
          foros_op << {
            foro: tolgeo_foro_class.new(
              user_name: username_subid_collective_prefixed
            ),
            op: 'destroy'
          }
        end

        return foros_op
      end

      if iscolectivo
        # El usuario pasa de No Consultoria a Consultoria/Colectivo
        foros_op << {
          foro: tolgeo_group_foro_class.new(
            user_group: username_group_prefixed,
            permis: "c#{subid_permisos}"
          ),
          op: 'create'
        }
        user_subscriptions.each do |us|
          oldsubscriptionid = us.oldsubscriptionid.nil? ? us.id : us.oldsubscriptionid
          foros_op << {
            foro: tolgeo_foro_class.new(
              user_name: "#{subid_prefix}#{oldsubscriptionid}",
              user_email: us.perusuid,
              user_pass: FAKE_SECRET,
              user_groups: username_group_prefixed,
              user_style: subid_styles
            ),
            op: 'create'
          }
        end

        return foros_op
      end

      # El usuario pasa de No Consultoria a Consultoria/No colectivo
      foros_op << {
        foro: tolgeo_foro_class.new(
          user_name: username_subid_collective_prefixed,
          user_email: email,
          user_pass: password,
          user_groups: "c#{subid_permisos}",
          user_style: subid_styles
        ),
        op: 'create'
      }
    end

    def foros_to_colectivo_change
      foros_op = []
      return foros_op unless !consultoria_changed? && has_consultoria?

      #  El usuario pasa de Consultoria/No Colectivo a Consultoria/Colectivo
      if iscolectivo
        # Se da de baja al usuario
        foros_op << {
          foro: tolgeo_foro_class.new(
            user_name: username_subid_collective_prefixed
          ),
          op: 'destroy'
        }
        # Se da de alta el grupo C<usuario> con permisos ctol
        foros_op << {
          foro: tolgeo_group_foro_class.new(
            user_group: username_group_prefixed,
            permis: "c#{subid_permisos}"
          ),
          op: 'create'
        }
        # Se añaden todos los usuarios de foros/personalización TOL<persoid>
        # el nuevo grupo C<usuario> y estilo ctol
        user_subscriptions.each do |us|
          oldsubscriptionid = us.oldsubscriptionid.nil? ? us.id : us.oldsubscriptionid
          foros_op << {
            foro: tolgeo_foro_class.new(
              user_name: "#{subid_prefix}#{oldsubscriptionid}",
              user_email: us.perusuid,
              user_pass: FAKE_SECRET,
              user_groups: username_group_prefixed,
              user_style: subid_styles
            ),
            op: 'create'
          }
        end

        return foros_op
      end
      # El usuario pasa de Consultoria/Colectivo a Consultoria/No Colectivo
      # Se mueven todos los usuarios del grupo C<usuario> al grupo tol
      foros_op << {
        foro: tolgeo_group_foro_class.new(
          user_group: username_group_prefixed,
          user_groups: subid_permisos,
          user_style: subid_styles
        ),
        op: 'move'
      }
      # Se da de baja el grupo C<usuario>
      foros_op << {
        foro: tolgeo_group_foro_class.new(
          user_group: username_group_prefixed
        ),
        op: 'destroy'
      }

      # Se crea el usuario CTOL<usuario> con permisos a ctol y estilo ctol
      foros_op << {
        foro: tolgeo_foro_class.new(
          user_name: username_subid_collective_prefixed,
          user_email: email,
          user_pass: password,
          user_groups: "c#{subid_permisos}",
          user_style: subid_styles
        ),
        op: 'create'
      }
    end

    def consultoria_changed?
      has_consultoria? != has_consultoria_before
    end

    def allowed_subsystem?
      subsystem_tirantonline? ||
        subsystem_notaries? ||
        subsystem_tolmex? ||
        subsystem_conmex?
    end

    def subsystem_tirantonline?
      tolgeo == 'esp' && Esp::Subsystem::TIRANTONLINE == subid
    end

    def subsystem_notaries?
      tolgeo == 'esp' && Esp::Subsystem::NOTARIOS == subid
    end

    def subsystem_tolmex?
      tolgeo == 'mex' && Mex::Subsystem::TOLMEX == subid
    end

    def subsystem_conmex?
      tolgeo == 'mex' && Mex::Subsystem::CONTADORES == subid
    end

    def subid_prefix
      tolgeo_foro_class::TOLGEO_SUBID_PREFIX[subid.to_s.to_sym]
    end

    def subid_permisos
      tolgeo_foro_class::TOLGEO_SUBID_PERMISOS[subid.to_s.to_sym]
    end

    def subid_styles
      tolgeo_foro_class::TOLGEO_SUBID_STYLES[subid.to_s.to_sym]
    end

    def prefix_grupo
      return tolgeo_foro_class::TOLGEO_PREFIXGRUPO[subid.to_s.to_sym] if tolgeo == 'mex'

      tolgeo_foro_class::TOLGEO_PREFIXGRUPO
    end

    def tolgeo_foro_class
      "#{tolgeo.capitalize}::Foro".constantize
    end

    def tolgeo_group_foro_class
      "#{tolgeo.capitalize}::GroupForo".constantize
    end

    def username_group_prefixed
      "#{prefix_grupo}#{username}"
    end

    def username_subid_collective_prefixed
      "C#{subid_prefix}#{username}"
    end
  end
end

# rubocop:enable Metrics/ModuleLength
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
