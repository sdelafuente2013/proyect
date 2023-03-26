# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Esp::User.skip_callback(:create, :after, :create_foro)
Esp::UserSubscription.skip_callback(:create, :after, :create_foro)

Tirantid::LopdUser.destroy_all()
Esp::UserSession.destroy_all()
Esp::UserSubscriptionCase.destroy_all()
Esp::UserSubscriptionAssumption.destroy_all()
Esp::UserSessionToken.destroy_all()

subsystem = FactoryBot.create(:subsystem, id: 1)
FactoryBot.create_list(:group, 2)
FactoryBot.create_list(:access_type, 2)
FactoryBot.create_list(:user_type_group, 2)
FactoryBot.create_list(:user, 2, maxconexiones: 50)

Esp::User.all.each do|user|
  user.total_sessions_class.by_user_id(user.id.to_s).destroy_all
  user.userIps.destroy_all
end

FactoryBot.create_list(:access_type_tablet, 2)
FactoryBot.create_list(:subsystem, 2)
FactoryBot.create_list(:ambit, 2)
FactoryBot.create_list(:modulo, 2)
FactoryBot.create_list(:subject, 2)
FactoryBot.create_list(:product, 2)
FactoryBot.create_list(:user_presubscription, 2)
FactoryBot.create_list(:user_subscription, 2, subsystem: subsystem)
FactoryBot.create_list(:access_error, 2)
FactoryBot.create_list(:document_type, 2)
FactoryBot.create_list(:user_stat, 2)
FactoryBot.create(:tolgeo, id: 0)
u = FactoryBot.create(:backoffice_user_with_associations, email: 'user@backoffice.com', password_digest: "$2a$10$xLJ7.cwvTffSaHdWeAWWv.XHJlIa2cUIRoecsdcb2NJvIxL2BDvCW") # password = 12345678
u.check_default_tolgeo
u.active=true
u.save
FactoryBot.create(:role, id: 0)
Tirantid::LopdApp.by_db_tolgeo('esp').first_or_create
FactoryBot.create_list(:deleted_user, 30)
FactoryBot.create_list(:user_session_esp, 30, :userId => Esp::User.last.id.to_s)
FactoryBot.create_list(:user_session_token_esp, 5)

user = FactoryBot.create(:user, :maxconexiones => 1, :datelimit => nil)
FactoryBot.create(:user_session_esp, :id => "5d038d2be95667a76c514dcd", :invalidated => false, :userId => user.id.to_s)
FactoryBot.create(:user_subscription, user: user, subsystem: subsystem, perusuid: "pepito@pepito.es", password: "sorianodepus")

FactoryBot.create_list(:esp_user_subscription_case, 5)
FactoryBot.create(:esp_user_subscription_case, :id => "casodesoriano")
FactoryBot.create_list(:user_subcription_assumption_esp, 5, user_subscription_id: 1, user_subscription_case_id: "casodesoriano")

Esp::User.first.userIps.destroy_all

FactoryBot.create_list(:document_alert, 5) 
FactoryBot.create_list(:commercial_contact, 5)

puts "END SEEDS"
