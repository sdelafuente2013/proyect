class Users::CreateWithSubscription < BaseService
  pattr_initialize :user_params, :user, :tolgeo

  def call
    return unless create_with_subscription

    subscription = create_subscription

     if create_with_email
        User::SendFullDataJob.perform_later({
        user: user,
        user_subscription: subscription
        })
     end
  end

  private

  def create_with_subscription
    user.valid? && !!user_params[:add_perso_account]
  end

  def create_with_email
    user_params[:has_to_send_welcome_email]
  end

  def create_subscription
    subscription_model.create!(
      perusuid: user_params[:email],
      password: user_params[:password],
      usuarioid: user.id,
      subid: user_params[:subid],
      comercial: user.comercial,
      grupo: user.grupo,
      privacidad: user.privacidad,
      sent_email_creation: false
    )
  end

  def subscription_model
    Objects.tolgeo_model_class(tolgeo, 'user_subscription')
  end
end
