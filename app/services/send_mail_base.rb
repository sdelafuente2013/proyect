class SendMailBase < BaseService
  pattr_initialize :email_type, :params

  def call!
    return unless class_data

    if is_a_mailer?
      klass.with(processed_params).send(method).deliver_later
    else # is a job
      klass.perform_later(processed_params)
    end
  end

  private

  def method
    class_data.third
  end

  def klass
    class_data.second
  end

  def is_a_mailer?
    class_data.first == :mailer
  end

  def class_data
    @class_data ||= mapping[email_type.to_sym]
  end

  def processed_params
    params[:extra_params]
  end

  def mapping
    {
      email_call_back: [:mailer, AdminMailer, :email_call_back]
    }
  end
end
