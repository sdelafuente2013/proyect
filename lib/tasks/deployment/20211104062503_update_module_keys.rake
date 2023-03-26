# frozen_string_literal: true

namespace :after_party do
  desc "Deployment task: update_module_keys"
  task update_module_keys: :environment do
    puts "Running deploy task 'update_module_keys'"

    permissions_key_replacement = {
      "Tirant Analytics" => "analytics",
      "Sofia" => "sofia",
      "Gestion Despachos" => "despachos",
      "Gestion despachos Plus" => "despachos"
    }

    %w[esp mex latam].each do |tolgeo|
      class_modulo = Objects.tolgeo_model_class(tolgeo, "modulo")

      permissions_key_replacement.each do |module_name, module_key|
        modulo = class_modulo.by_nombre(module_name)
        modulo.update(key: module_key) if modulo.present?
      end
    end

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end
