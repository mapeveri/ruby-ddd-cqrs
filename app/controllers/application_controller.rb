class ApplicationController < ActionController::API
  rescue_from StandardError, with: :handle_exception

  private
    STATUS_MAP = {
      "ActiveRecord::RecordNotFound" => :not_found,
      "ActionController::ParameterMissing" => :bad_request,
      "ActiveRecord::RecordInvalid" => :unprocessable_entity
    }.freeze

    def handle_exception(exception)
      status = STATUS_MAP.fetch(exception.class.to_s, :internal_server_error)

      Rails.logger.error exception.full_message

      payload = {
        status: status,
        message: exception.message
      }
      payload[:backtrace] = exception.backtrace if Rails.env.development?

      render json: payload, status: status
    end
end
