module Latam
  class LatamBase < ApplicationRecord
    establish_connection DB_LATAM
    self.abstract_class = true
  end
end

