FactoryBot.define do
  
  factory :lopd_app, class: 'Tirantid::LopdApp' do
      nombre do
            loop do
              possible_name = Faker::Internet.unique.user_name
              break possible_name unless Tirantid::LopdApp.exists?(nombre: possible_name)
            end
      end
  end
  

end

