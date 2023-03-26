namespace :after_party do
  desc "Deployment task: update_sofia_origin"
  task update_sofia_origin: :environment do
    tolgeos = ["esp", "mex"]
    tolgeos.each do |tolgeo|
      class_commercial_contacts = Objects.tolgeo_model_class(tolgeo, "commercial_contact")
      class_commercial_contacts.by_origin("Sofía. Detalle del documento")
                                .update_all(origen: "Solicitud Información SOFIA")
    end

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end
