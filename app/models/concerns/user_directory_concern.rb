module UserDirectoryConcern
  extend ActiveSupport::Concern

  included do
    self.table_name = 'per_directory'
    self.inheritance_column = nil

    belongs_to :user_subscription,
               foreign_key: 'persubscription_id',
               inverse_of: :user_directories
  end
end
