module SubsystemConcern
  extend ActiveSupport::Concern

  included do
    include Searchable
    self.table_name = 'subsystem'

    has_many :users, :foreign_key => 'subid'
    has_many :modulo_subsystems, foreign_key: 'subid'
    has_many :modulo_premium_subsystems, foreign_key: 'subid'
    has_many :commercial_contacts, foreign_key: 'subid'

    searchable_by :name
    
    def full_url
      [self.url, self.path].join("/")
    end

  end
end

