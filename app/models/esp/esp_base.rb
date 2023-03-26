module Esp
  class EspBase < ApplicationRecord
    establish_connection DB_DEFAULT
    self.abstract_class = true
  end
end
