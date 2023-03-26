# frozen_string_literal: true

namespace :after_party do
  desc 'Deployment task: new_services_tools'
  task new_services_tools: :environment do
    puts "Running deploy task 'new_services_tools'"

    Latam::Service.find_or_create_by(
      clave: 'labor_calculator',
      subid: 5
    ).update!(
      orden: 120,
      hide: 0,
      grupoid: 45
    )

    Latam::Service.find_or_create_by(
      clave: 'judicial_interests',
      subid: 5
    ).update!(
      orden: 140,
      hide: 0,
      grupoid: 45
    )
    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end
