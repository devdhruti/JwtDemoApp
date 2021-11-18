module Api
  module V1
    class BaseController < ApplicationController
      protect_from_forgery with: :null_session

      # response
      def json_response(data, option = nil)
        if option.present?
          return render json: {success: true, data: data, meta_key: option, error: []}, status:200
        else
          render json: {success: true, data: data, error: []}, status:200
        end
      end

      # generic
      rescue_from Exception do |exception|
        render_exception exception, 422
      end
      # # 404
      rescue_from ActionController::RoutingError, ActiveRecord::RecordNotFound do |exception|
        render_exception exception, 404
      end

      # Routing error
      def routing_error
        render json: {
          success: false,
          data: {},
          errors: ('Page not found')
        }, status: 404
      end

      def render_exception(exception = nil, code = 500)
        unless code == 422
          Rails.logger.error exception.message
          Rails.logger.error exception.backtrace.join("\n")
        end

        if (code != 428)
          render json: {
            success: false,
            data: {},
            errors: (exception.message)
          }, status: code
        else
          render json: {
            success: false,
            data: {},
            errors: JSON.parse(exception.message)
          }, status: code
        end
      end 

    end
  end
end
