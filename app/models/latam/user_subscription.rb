class Latam::UserSubscription < Latam::LatamBase
  include UserSubscriptionConcern

  def enable_newsletter=(enable_newsletter)
    unless enable_newsletter.nil?
      self.news = enable_newsletter
      self.countrynews = enable_newsletter
    end
  end
end

