class UserSubscriptionMailerPreview < ActionMailer::Preview
  def email_passwd_esp
    user_subscription = Esp::UserSubscription.first
    UserSubscriptionMailer.with(user_subscription:user_subscription, change_password_url: "http://www.example.com").email_passwd
  end

  def email_passwd_mex
    user_subscription = Mex::UserSubscription.first
    UserSubscriptionMailer.with(user_subscription:user_subscription, change_password_url: "http://www.example.com").email_passwd
  end

  def email_passwd_latam
    user_subscription = Latam::UserSubscription.first
    UserSubscriptionMailer.with(user_subscription:user_subscription, change_password_url: "http://www.example.com").email_passwd
  end

  %w(esp mex latam).each do |tolgeo|
    define_method("request_password_recovery_#{tolgeo}") do
      UserSubscriptionMailer
        .with(
          user_subscription: "#{tolgeo.capitalize}::UserSubscription".constantize.first,
          user: "#{tolgeo.capitalize}::User".constantize.first,
          change_password_url: "http://www.example.com/wololo"
        )
        .request_password_recovery
    end
  end
end
