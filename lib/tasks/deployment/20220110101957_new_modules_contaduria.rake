# frozen_string_literal: true

namespace :after_party do
  desc "Deployment task: new_modules_contaduria"
  task new_modules_contaduria: :environment do
    puts "Running deploy task 'new_modules_contaduria'"
    contadores_subid = 1

    new_modules = [
      { name: "Consultoría", orden: nil },
      { name: "Consultoría Mobile", orden: nil },
      { name: "Biblioteca Virtual", orden: 10 },
      { name: "Novedades", orden: 30 },
      { name: "Foros", orden: 40 },
      { name: "Gestión Despachos", orden: 50 },
      { name: "Tirant Derechos Humanos", orden: 60 },
      { name: "Petición de Formularios", orden: 70 },
      { name: "Tirant Online España", orden: nil },
      { name: "Revistas Tirant Lo Blanch", orden: 100 },
      { name: "Latam", orden: 105 },
      { name: "Biblioteca Virtual Latam", orden: 110 },
      { name: "Tirant Analytics", orden: 120 },
      { name: "Sofia", orden: 240 }
    ]

    new_modules.each do |new_module|
      new_moduloid = Mex::Modulo.by_nombre(new_module[:name]).first[:id]
      Mex::ModuloSubsystem.find_or_create_by!(
        moduloid: new_moduloid,
        subid: contadores_subid,
        orden: new_module[:orden]
      )
    end

    new_premium_modules = [
      "Consultoría",
      "Biblioteca Virtual",
      "Gestión Despachos",
      "Tirant Derechos Humanos",
      "Tirant Online España",
      "Revistas Tirant Lo Blanch",
      "Latam",
      "Tirant Analytics",
      "Sofia"
    ]

    new_premium_modules.each do |new_premium_module_name|
      new_moduloid = Mex::Modulo.by_nombre(new_premium_module_name).first[:id]
      Mex::ModuloPremiumSubsystem.find_or_create_by!(
        moduloid: new_moduloid,
        subid: contadores_subid
      )
    end

    # Update task as completed.  If you remove the line below, the task will
    # run with every deploy (or every time you call after_party:run).
    AfterParty::TaskRecord
      .create version: AfterParty::TaskRecorder.new(__FILE__).timestamp
  end
end
