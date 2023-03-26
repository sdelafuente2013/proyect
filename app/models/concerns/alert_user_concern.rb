module AlertUserConcern
  extend ActiveSupport::Concern

  included do
    has_many :document_alerts, as: :alertable

    validates_presence_of :email
  end
end
