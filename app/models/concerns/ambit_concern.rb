module AmbitConcern
  extend ActiveSupport::Concern

  included do
    include Searchable
    self.table_name = 'ambito'

    searchable_by :nombre

    def to_json(options = {})
      self.as_json(options)
    end

    def as_json(options = {})
      options[:methods] ||= []
      options[:methods] += [:id]
      super(options)
    end
  end
end
