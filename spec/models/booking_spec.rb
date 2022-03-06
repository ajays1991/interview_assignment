require 'rails_helper'

RSpec.describe Booking, type: :model do
  context "test booking business rules" do
    let(:provisional_booking) { create(:booking, :provisional) }

    it "confirms the booking for user " do
      provisional_booking = create(:booking, :provisional_approved_user)
      provisional_booking.current_user = provisional_booking.user
      confirm_response = provisional_booking.confirm({confirmation_type: "sms", send_confirmation_msg: true})
      assert confirm_response[:success], true
    end

    it "rejects booking if user not approved" do
      provisional_booking = create(:booking, :provisional_unapproved_user)
      provisional_booking.current_user = provisional_booking.user
      confirm_response = provisional_booking.confirm({confirmation_type: "sms", send_confirmation_msg: true})
      assert confirm_response, ["User not allowed to confirm booking"]
    end

    it "rejects booking if user doesn't belong to booking" do
      provisional_booking = create(:booking, :provisional_approved_user)
      provisional_booking.current_user = create(:user, :approved)
      confirm_response = provisional_booking.confirm({confirmation_type: "sms", send_confirmation_msg: true})
      assert confirm_response, ["User not allowed to confirm booking"]
    end

    it "rejects booking if booking start date is in past" do
      provisional_booking = create(:booking, :provisional_approved_user_expired)
      provisional_booking.current_user = provisional_booking.user
      confirm_response = provisional_booking.confirm({confirmation_type: "sms", send_confirmation_msg: true})
      assert confirm_response, ["Booking in past cannot be confirmed"]
    end

    it "rejects booking if state is confirmed" do
      provisional_booking = create(:booking, :confirmed_approved_user)
      provisional_booking.current_user = provisional_booking.user
      confirm_response = provisional_booking.confirm({confirmation_type: "sms", send_confirmation_msg: true})
      assert confirm_response, ["Booking cannot be confirmed"]
    end

    it "rejects booking if state is cancelled" do
      provisional_booking = create(:booking, :cancel_approved_user)
      provisional_booking.current_user = provisional_booking.user
      confirm_response = provisional_booking.confirm({confirmation_type: "sms", send_confirmation_msg: true})
      assert confirm_response, ["Booking cannot be confirmed"]
    end
  end

  context "Test booking success with send confirmation" do

    it "sends booking confirmation to user for SMS" do
      provisional_booking = create(:booking, :provisional_approved_user)
      provisional_booking.current_user = provisional_booking.user
      expect_any_instance_of(SmsSender).to receive(:deliver)
      confirm_response = provisional_booking.confirm({confirmation_type: "sms"})
    end

    it "sends booking confirmation to user for Email" do
      provisional_booking = create(:booking, :provisional_approved_user)
      provisional_booking.current_user = provisional_booking.user
      expect_any_instance_of(EmailSender).to receive(:deliver)
      confirm_response = provisional_booking.confirm({confirmation_type: "email"})
    end
  end
end
