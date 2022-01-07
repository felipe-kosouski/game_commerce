# frozen_string_literal: true

module Admin
  module V1
    class HomeController < ApiController
      def index
        render json: { message: 'aeeew' }
      end
    end
  end
end
