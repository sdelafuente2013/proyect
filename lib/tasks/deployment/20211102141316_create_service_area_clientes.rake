namespace :after_party do
  desc 'Deployment task: create_service_area_clientes'
  task create_service_area_clientes: :environment do
    puts "Running deploy task 'create_service_area_clientes'"

    Esp::Service.find_or_create_by(
      clave: 'area_clientes',
      subid: 0
    ).update!(
      orden: 240,
      grupoid: 1
    )

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end