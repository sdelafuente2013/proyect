FactoryBot.define do
  factory :user_session_token_esp, class: 'Esp::UserSessionToken' do
    session_id { "5d038d2be95667a76c514dcd" }
    filters { 
              {"name" => "platano", 
               "arraydesorianos" => [1,3,5],
               "frutas" => {"platano" => 1, "manzana" => 2},
               "valor" => 1,
               "frutas_ids" => {"0" => {"name" => "platano", "value" => [1,4,5]}, 
                                "1" => {"name" => "manzana", "value" => [1,4,5]}}
               } 
            }
  end
end
