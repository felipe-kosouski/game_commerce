# frozen_string_literal: true

module Admin
  module V1
    class CategoriesController < ApiController
      def index
        @categories = Category.all
      end
    end
  end
end
