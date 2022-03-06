# frozen_string_literal: true

class Booking < ApplicationRecord

  belongs_to :user
  belongs_to :host, optional: true
  belongs_to :confirmed_by, class_name: 'User', optional: true

  validates :start_time, presence: true
  validates :end_time, presence: true

  attr_accessor :current_user

  def confirm(confirm_attributes)
    errors = []
    if !current_user.approved || user_id != current_user.id
      errors << "User not allowed to confirm booking"
    end 
    if start_time < DateTime.now
      errors << "Booking in past cannot be confirmed"
    end
    if ['confirmed', 'cancelled', 'Expired'].include? state
      errors << "Booking cannot be confirmed"
    end
    if !errors.empty?
      return errors
    end

    update!(state: 'confirmed', confirmed_by: current_user, confirmed_at: DateTime.now)
    if confirm_attributes[:confirmation_type] == 'sms'
      SmsSender.new(user.mobile, "").deliver
      SmsSender.new(host.mobile, "").deliver if confirm_attributes[:send_confirmation_msg] && host
    else
      EmailSender.new(user.email, "").deliver
      EmailSender.new(host.email, "").deliver if confirm_attributes[:send_confirmation_msg] && host
    end
    return {
      success: true
    }
  end
end
