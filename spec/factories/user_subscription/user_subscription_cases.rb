FactoryBot.define do
  factory :esp_user_subscription_case, class: 'Esp::UserSubscriptionCase' do
    namecase { Faker::Lorem.characters(5) }
    summary { Faker::Lorem.characters }
    documents { Faker::Lorem.words(4) }
    annotations { Faker::Lorem.words(4) }
    user_subscription_id { Faker::Lorem.characters(5) }
    folderContent { "
      [ 
        {
          'type' : 'folder',
          'name' : 'Pruebas incriminatorias',
          'id' : '111',
          'children' : [ 
            {
              'name' : 'Documento que habla del cuchillo',
              'type' : 'doc',
              'id' : '6767'
            }, 
            {
              'name' : 'Documento que habla de la pistola',
              'type' : 'doc',
              'id' : '888'
            }
          ]
        }, 
        {
          'type' : 'folder',
          'name' : 'Sentencias',
          'id' : '222',
          'children' : [ 
            {
              'name' : 'Sentencia a favor del acusado',
              'type' : 'doc',
              'id' : '999'
            }
            ]
        }
      ]"
  }
  downloadUrl { Faker::Lorem.characters(5) }
  end

  factory :latam_user_subscription_case, class: 'Latam::UserSubscriptionCase' do
    namecase { Faker::Lorem.characters(5) }
    summary { Faker::Lorem.characters }
    documents { Faker::Lorem.words(4) }
    annotations { Faker::Lorem.words(4) }
    user_subscription_id { Faker::Lorem.characters(5) }
    folderContent { "
      [ 
        {
          'type' : 'folder',
          'name' : 'Pruebas incriminatorias',
          'id' : '111',
          'children' : [ 
            {
              'name' : 'Documento que habla del cuchillo',
              'type' : 'doc',
              'id' : '6767'
            }, 
            {
              'name' : 'Documento que habla de la pistola',
              'type' : 'doc',
              'id' : '888'
            }
          ]
        }, 
        {
          'type' : 'folder',
          'name' : 'Sentencias',
          'id' : '222',
          'children' : [ 
            {
              'name' : 'Sentencia a favor del acusado',
              'type' : 'doc',
              'id' : '999'
            }
            ]
        }
      ]"
  }
  downloadUrl { Faker::Lorem.characters(5) }
  end
end
