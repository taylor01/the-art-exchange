class SessionsController < ApplicationController
  before_action :redirect_if_signed_in, only: [ :new, :create ]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:email]&.downcase&.strip)

    if @user&.confirmed?
      if params[:login_method] == "password" && @user.password_digest.present?
        handle_password_login
      else
        handle_otp_login
      end
    else
      handle_invalid_login
    end
  end

  def destroy
    sign_out
    redirect_to root_path, notice: "You have been signed out."
  end

  private

  def redirect_if_signed_in
    redirect_to root_path if user_signed_in?
  end

  def handle_password_login
    if @user.authenticate(params[:password])
      if @user.locked?
        render :new, alert: "Account is temporarily locked. Please try again later."
      else
        @user.update_login_tracking!
        sign_in(@user)
        redirect_back_or_to(root_path)
      end
    else
      @user.increment!(:failed_login_attempts)
      @user.lock_account! if @user.failed_login_attempts >= @user.auth_config[:max_failed_login_attempts]
      handle_invalid_login
    end
  end

  def handle_otp_login
    if @user.locked?
      render :new, alert: "Account is temporarily locked. Please try again later."
    else
      token = @user.generate_otp!
      AuthenticationMailer.otp_email(@user, token).deliver_now
      session[:otp_user_id] = @user.id
      redirect_to otp_verification_path, notice: "We've sent a verification code to your email."
    end
  end

  def handle_invalid_login
    @user = User.new(email: params[:email])
    render :new, alert: "Invalid email or password."
  end
end
