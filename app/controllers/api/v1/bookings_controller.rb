module Api
	module V1
		class BookingsController < ApplicationController
			def confirm
				booking = Booking.find(confirm_attributes[:id])
				booking.current_user = current_user
				response = booking.confirm(confirm_attributes)
				render json: {
					result: response
				}
			end

			private

			def confirm_attributes
				params.permit(:send_confirmation_msg, :confirmation_type, :id)
			end
		end
	end
end