class MassiveUsersJob < ActiveJob::Base
  queue_as :default

  def perform(tolgeo, user_params, locale)
     Objects.tolgeo_model_class(tolgeo, 'user').import_users(user_params, locale)
  end

end
