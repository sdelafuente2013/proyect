class AddPasswordDigestMd5ToPerSubscription < ActiveRecord::Migration[5.1]
  def change
    add_column :per_subscription, :password_digest_md5, :string
  end
end
