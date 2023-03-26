class Mex::Ambit < Mex::MexBase
  include AmbitConcern
  alias_attribute :id, :ambitoid
end

