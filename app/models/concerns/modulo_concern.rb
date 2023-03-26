# frozen_string_literal: true

module ModuloConcern
  extend ActiveSupport::Concern

  BIBLIOTECA = 1
  FORMACION = 15
  CONSULTORIA = 4

  included do
    include Searchable
    self.table_name = "modulo"

    has_many :user_modulos, foreign_key: "moduloid", inverse_of: :modulos
    has_many :users, through: :user_modulos, source: :user
    has_many :modulo_subsystems, foreign_key: "moduloid"
    has_many :modulo_premium_subsystems, foreign_key: "moduloid"
    searchable_by :nombre

    scope :are_premium_by_subid, lambda { |subid|
      return all if subid.blank?

      joins(:modulo_premium_subsystems).where(modulo_premium_subsystem: { subid: subid })
    }

    scope :has_consultoria, lambda {
      where(id: consultoria_ids)
    }

    scope :no_formation, lambda { |no_formation|
      no_formation.blank? ? all : where.not(id: FORMACION)
    }

    scope :by_subid, lambda { |subid|
      return all if subid.blank?

      joins(:modulo_subsystems).where(modulo_subsystem: { subid: subid })
    }

    scope :by_nombre, lambda { |nombre|
      nombre.blank? ? all : where(nombre: nombre)
    }

    scope :by_key, lambda { |key|
      key.blank? ? all : where(key: key)
    }

    def self.search_scopes(params)
      are_premium_by_subid(params[:premium_subid])
        .no_formation(params[:no_formation])
        .by_subid(params[:subid])
        .by_nombre(params[:nombre])
        .by_key(params[:key])
    end
  end

  module ClassMethods
    def consultoria_ids
      [CONSULTORIA]
    end

    def is_consultoria?(id)
      consultoria_ids.include?(id)
    end
  end
end
