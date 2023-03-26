namespace :user_presubscriptions do
  desc 'Updates the encrypted password based on the initial password'
  task update_password: :environment do
    include UserSubscription::PasswordManagementConcern

    tolgeos = ['esp', 'mex', 'latam']

    tolgeos.each do |tolgeo|
      class_user_presubscription = Objects.tolgeo_model_class(tolgeo, 'user_presubscription')

      user_presubscriptions = class_user_presubscription
        .where(password_digest: nil, password_salt: nil)
        .or(class_user_presubscription.where(password_digest_md5: nil))
        .where.not(password: nil)

      user_presubscriptions.find_each do |user_presubscription|
        user_presubscription.password_salt = generate_password_salt

        user_presubscription.password_digest = generate_hashed_password(
          user_presubscription.password,
          user_presubscription.password_salt
        )

        user_presubscription.password_digest_md5 = generate_hashed_md5_password(
          user_presubscription.password,
          user_presubscription.password_salt
        )
        
        user_presubscription.save(validate: false)
      end
    end
  end
end
