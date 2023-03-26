module Mex
  class MexBase < ApplicationRecord
    establish_connection DB_MEXICO
    self.abstract_class = true
  end
end
