class SmsSender
  def initialize(email, message)
    @email  = email
    @message = message
  end

  def deliver
    Rails.logger.info "MSG sent to #{email}"
  end

  private

  attr_reader :email, :message
end
