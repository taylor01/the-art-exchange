class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Terms of Service enforcement
  before_action :ensure_current_terms_accepted

  protected

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
    nil
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_user!
    unless user_signed_in?
      store_location_for_user
      redirect_to new_session_path, alert: "Please sign in to continue."
    end
  end

  def sign_in(user)
    session[:user_id] = user.id
    @current_user = user
  end

  def sign_out
    session[:user_id] = nil
    @current_user = nil
  end

  def store_location_for_user
    session[:user_return_to] = request.fullpath if request.get? && !request.xhr?
  end

  def redirect_back_or_to(default_path)
    redirect_to(session.delete(:user_return_to) || default_path)
  end

  def ensure_current_terms_accepted
    return unless user_signed_in?
    return if skip_terms_enforcement?

    unless current_user.terms_current?
      store_location_for_user
      redirect_to terms_acceptance_path, alert: "Please review and accept our updated Terms of Service to continue."
    end
  end

  def skip_terms_enforcement?
    # Skip enforcement for certain controllers and actions
    controller_name.in?([ "sessions", "registrations", "legal", "terms_acceptance" ]) ||
    (controller_name == "password_resets") ||
    (controller_name == "otp")
  end

  helper_method :current_user, :user_signed_in?
end
