# typed: false


class ApplicationController < ActionController::Base
  extend T::Sig

  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ArgumentError, with: :argument_error
  rescue_from StandardError, with: :internal_server_error

  before_action :set_locale

  sig { returns(T::Hash[Symbol, T.untyped]) }
  def default_url_options
    { locale: I18n.locale }
  end

  private

  sig { params(exception: ActiveRecord::RecordNotFound).void }
  def record_not_found(exception)
    render_error("Запись не найдена", :not_found, exception)
  end

  sig { params(exception: ActiveRecord::RecordInvalid).void }
  def record_invalid(exception)
    render_error(
      "Ошибка валидации: #{exception.record.errors.full_messages.join(', ')}",
      :unprocessable_entity,
      exception
    )
  end

  sig { params(exception: ArgumentError).void }
  def argument_error(exception)
    render_error("Ошибка: #{exception.message}", :bad_request, exception)
  end

  sig { params(exception: StandardError).void }
  def internal_server_error(exception)
    render_error("Внутренняя ошибка сервера. Попробуйте позже.", :internal_server_error, exception)
  end

  sig do
    params(
      message: String,
      status: Symbol,
      exception: T.nilable(StandardError)
    ).void
  end
  def render_error(message, status, exception = nil)
    logger.error "Ошибка: #{message}"
    logger.error exception.backtrace.join("\n") if exception

    respond_to do |format|
      format.html { redirect_to root_path, alert: message }
      format.json { render json: { error: message }, status: status }
    end
  end

  sig { void }
  def set_locale
    I18n.locale = params[:locale] || extract_locale_from_accept_language_header || :ru
  end

  sig { returns(T.nilable(String)) }
  def extract_locale_from_accept_language_header
    request.env["HTTP_ACCEPT_LANGUAGE"]&.scan(/^[a-z]{2}/)&.first
  end
end