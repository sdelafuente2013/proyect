FactoryBot.define do

  factory :user_subscription_search, class: 'Latam::UserSubscriptionSearch' do
    is_alertable { true }
    alert_period { "semanal" }
    summary { Faker::Lorem.characters(40) }
    user_subscription_id { Faker::Number.between(1, 100000) }
    user_subscription_case_id { Faker::Number.between(1, 100000) }
    filters { 
              {"search_tokens" => ["buena fe", "contractual"],
              "search_type" => "jurisprudencia",
              "query_field" => "all",
              "query_format" => "substring ",
              "filters" => [{"name"=>"tiporesolucion_latam", "values"=>["Sentencia"], "operator"=>"OR"}, {"name"=>"ponente_latam", "values"=>["José Francisco Leyton Jiménez"], "operator"=>"OR"}, {"name"=>"origen_latam", "values"=>["Tribunal Constitucional"], "operator"=>"OR"}],
              "sort" => "score desc"
              }
            }
  end
  
  factory :user_subscription_search_2, class: 'Latam::UserSubscriptionSearch' do
    is_alertable { false }
    alert_period { "" }
    summary { Faker::Lorem.characters(40) }
    user_subscription_id { Faker::Number.between(1, 100000) }
    user_subscription_case_id { Faker::Number.between(1, 100000) }
    filters { 
              {"search_tokens" => ["buena fe", "contractual"],
              "search_type" => "jurisprudencia",
              "query_field" => "all",
              "query_format" => "substring ",
              "filters" => [{"name"=>"tiporesolucion_latam", "values"=>["Sentencia"], "operator"=>"OR"}, {"name"=>"ponente_latam", "values"=>["José Francisco Leyton Jiménez"], "operator"=>"OR"}, {"name"=>"origen_latam", "values"=>["Tribunal Constitucional"], "operator"=>"OR"}],
              "sort" => "score desc"
              }
            }
  end
end
