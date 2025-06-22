class OtpController < ApplicationController
  before_action :find_otp_user
  before_action :redirect_if_signed_in

  def show
    redirect_to new_session_path unless @user
  end

  def create
    unless @user
      redirect_to new_session_path, alert: "Session expired. Please sign in again."
      return
    end

    if @user.verify_otp(params[:otp_token])
      session.delete(:otp_user_id)
      sign_in(@user)
      redirect_back_or_to(root_path)
    else
      if @user.otp_locked?
        render :show, alert: "Too many failed attempts. Please wait before trying again."
      else
        render :show, alert: "Invalid verification code. Please try again."
      end
    end
  end

  def resend
    unless @user
      redirect_to new_session_path, alert: "Session expired. Please sign in again."
      return
    end

    if @user.otp_locked?
      flash.now[:alert] = "Too many attempts. Please wait before requesting a new code."
      render :show
    else
      token = @user.generate_otp!
      AuthenticationMailer.otp_email(@user, token).deliver_now
      flash.now[:notice] = "A new verification code has been sent to your email."
      render :show
    end
  end

  private

  def find_otp_user
    @user = User.find(session[:otp_user_id]) if session[:otp_user_id]
  rescue ActiveRecord::RecordNotFound
    @user = nil
  end

  def redirect_if_signed_in
    if user_signed_in?
      session.delete(:otp_user_id)
      redirect_to root_path
    end
  end
end
