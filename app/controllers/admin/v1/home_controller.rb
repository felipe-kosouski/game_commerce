module Admin::V1
    class HomeController < ApiController
        def index
            render json: { message: "aeeew" }
        end
    end
end
