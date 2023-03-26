class Esp::Tolgeo < Esp::EspBase
  include Searchable
  self.table_name = 'tolgeos'

  validates :name, { presence: true, uniqueness: true }
  validates :description, presence: true

  searchable_by :name
end

