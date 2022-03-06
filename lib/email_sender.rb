class EmailSender
  def initialize(email, message)
    @email  = email
    @message = message
  end

  def deliver
    Rails.logger.info "Email sent to #{email}"
  end

  private

  attr_reader :email, :message
end
