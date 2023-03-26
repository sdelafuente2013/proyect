namespace :after_party do
  desc 'Deployment task: update_tlb_services'
  task update_tlb_services: :environment do
    puts "Running deploy task 'update_tlb_services'"

    ['5', '6', '7'].each do |subid|
      Latam::Service.by_clave("textoslegalesbasicos").by_subid(subid).each do |service|
          service.update(:orden=> 55, :hide => 0)
      end
    end

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end