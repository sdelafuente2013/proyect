class Users::CreateWithEmail < BaseService
  pattr_initialize :email, :perso_account, :user

  def call
    return unless create_with_email

    User::SendFullDataJob.perform_later({
      user: @user,
      user_subscription: nil
    })
  end

  private

  def create_with_email
    email && !!!perso_account
  end
end
