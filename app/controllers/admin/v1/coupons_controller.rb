# frozen_string_literal: true

module Admin
  module V1
    class CouponsController < ApiController
      before_action :set_coupon, only: %i[update destroy]

      def index
        @coupons = Coupon.all
      end

      def create
        @coupon = Coupon.new
        @coupon.attributes = coupon_params
        save_coupon!
      end

      def update
        @coupon.attributes = coupon_params
        save_coupon!
      end

      def destroy
        @coupon.destroy!
      rescue StandardError
        render_error(fields: @coupon.errors.messages)
      end

      private

      def set_coupon
        @coupon = Coupon.find(params[:id])
      end

      def coupon_params
        return {} unless params.key?(:coupon)

        params.require(:coupon).permit(:code, :status, :discount_value, :due_date)
      end

      def save_coupon!
        @coupon.save!
        render :show
      rescue StandardError
        render_error(fields: @coupon.errors.messages)
      end
    end
  end
end
