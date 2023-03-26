class Esp::Role < Esp::EspBase
  include Searchable
  self.table_name = 'roles'
  default_scope { order(:id) }

  validates :description, { presence: true, uniqueness: true }

  searchable_by :description
end

