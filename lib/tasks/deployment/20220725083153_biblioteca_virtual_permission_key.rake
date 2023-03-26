# frozen_string_literal: true

namespace :after_party do
  desc 'Deployment task: biblioteca_virtual_permission_key'
  task biblioteca_virtual_permission_key: :environment do
    puts "Running deploy task 'biblioteca_virtual_permission_key'"

    %w[esp mex latam].each do |tolgeo|
      class_modulo = Objects.tolgeo_model_class(tolgeo, 'modulo')
      modulo = class_modulo.by_nombre('Biblioteca Virtual')
      modulo.update(key: 'biblioteca_virtual') if modulo.present?
    end

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end
