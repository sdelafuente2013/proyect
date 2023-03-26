require "ipaddr"
module UserIpConcern
  extend ActiveSupport::Concern

  included do
    self.table_name = 'userips'

    belongs_to :user, :foreign_key => 'usuarioid', inverse_of: :userIps

    validate :ips_with_same_format

    def ip_belongs_to_range?(address)
      (IPAddr.new(self.ipfrom).to_i..IPAddr.new(self.ipto).to_i)===IPAddr.new(address).to_i
    end

    def to_pretty
      "#{ipfrom} to #{ipto}"
    end

    def ips_with_same_format
      ip_from = IPAddr.new(ipfrom)
      ip_to = IPAddr.new(ipto)

      return if (ip_from.ipv4? && ip_to.ipv4?) || (ip_from.ipv6? && ip_to.ipv6?)

      errors.add(:format, I18n.t('user_ip.errors.format'))
    rescue IPAddr::InvalidAddressError
      errors.add(:format, I18n.t('user_ip.errors.format'))
    end
  end
end
