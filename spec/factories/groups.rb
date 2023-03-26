FactoryBot.define do

  factory :group, class: 'Esp::Group' do
    descripcion { Faker::Lorem.word }
    tipoid { create(:user_type_group).id }
    pais { Faker::Number.number(1) }
    factory :group_show_demo_enabled do    
      show_demo {1}
    end 
    factory :group_show_demo_disabled do    
      show_demo {0}
    end 
  end

end
