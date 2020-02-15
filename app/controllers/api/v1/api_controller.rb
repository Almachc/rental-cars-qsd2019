class Api::V1::ApiController < ActionController::API
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

    rescue_from ActiveRecord::RecordInvalid,
                ActionController::ParameterMissing,
                ArgumentError,
                with: :render_unprocessable_entity

    rescue_from ActiveRecord::ConnectionNotEstablished, with: :render_internal_server_error

    def render_not_found(exception)
        render json: { notice: I18n.t(:not_found,
                                      scope: [:http_statuses, :messages])
                     }, status: :not_found
    end

    def render_unprocessable_entity(exception)
        render json: { notice: I18n.t(:unprocessable_entity,
                                      scope: [:http_statuses, :messages])
                     }, status: :unprocessable_entity
    end

    def render_internal_server_error(exception)
        render json: { notice: I18n.t(:internal_server_error,
                                      scope: [:http_statuses, :messages])
                     }, status: :internal_server_error
    end
end
