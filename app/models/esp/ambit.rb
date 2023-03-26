class Esp::Ambit < Esp::EspBase
  include AmbitConcern
  alias_attribute :id, :ambitoid
end

