namespace :user_subscriptions do
  desc 'Updates the encrypted password based on the initial password'
  task update_password: :environment do
    include UserSubscription::PasswordManagementConcern

    tolgeos = ['esp', 'mex', 'latam']

    tolgeos.each do |tolgeo|
      class_user_subscription = Objects.tolgeo_model_class(tolgeo, 'user_subscription')

      user_subscriptions = class_user_subscription
        .where(password_digest: nil, password_salt: nil)
        .or(class_user_subscription.where(password_digest_md5: nil))
        .where.not(password: nil)

      user_subscriptions.find_each do |user_subscription|
        user_subscription.password_salt = generate_password_salt

        user_subscription.password_digest = generate_hashed_password(
          user_subscription.password,
          user_subscription.password_salt
        )

        user_subscription.password_digest_md5 = generate_hashed_md5_password(
          user_subscription.password,
          user_subscription.password_salt
        )
        
        user_subscription.save(validate: false)
      end
    end
  end
end
