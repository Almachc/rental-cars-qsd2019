class Api::V1::ApiController < ActionController::API
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

    rescue_from ActiveRecord::RecordInvalid,
                ActionController::ParameterMissing,
                ArgumentError,
                with: :render_unprocessable_entity

    rescue_from ActiveRecord::ConnectionNotEstablished, with: :render_internal_server_error

    def render_not_found(exception)
        render json: { notice: exception.message }, status: :not_found
    end

    def render_unprocessable_entity(exception)
        render json: { notice: exception.message }, status: :unprocessable_entity
    end

    def render_internal_server_error(exception)
        render json: { notice: exception.message }, status: :internal_server_error
    end
end