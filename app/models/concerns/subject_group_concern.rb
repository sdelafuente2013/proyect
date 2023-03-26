module SubjectGroupConcern
  extend ActiveSupport::Concern

  included do
    self.table_name = 'grupo_materia'
    has_many :gm_usuarios, :foreign_key => 'gmid', inverse_of: :subject_group, dependent: :delete_all
  end
end

