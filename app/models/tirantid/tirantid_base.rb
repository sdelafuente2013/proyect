module Tirantid
  class TirantidBase < ApplicationRecord
    establish_connection DB_TIRANTID
    self.abstract_class = true
  end
end
