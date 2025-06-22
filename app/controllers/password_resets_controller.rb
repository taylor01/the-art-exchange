class PasswordResetsController < ApplicationController
  before_action :find_user_by_token, only: [ :show, :update ]

  def new
  end

  def create
    @user = User.find_by(email: params[:email]&.downcase&.strip)

    if @user&.confirmed?
      @user.generate_reset_password_token!
      AuthenticationMailer.password_reset_email(@user).deliver_now
      redirect_to new_password_reset_path, notice: "Password reset instructions have been sent to your email."
    else
      render :new, alert: "Email not found or account not confirmed."
    end
  end

  def show
    redirect_to new_password_reset_path, alert: "Invalid or expired reset link." unless @user
  end

  def update
    unless @user
      redirect_to new_password_reset_path, alert: "Invalid or expired reset link."
      return
    end

    if params[:user][:password].present? && params[:user][:password] == params[:user][:password_confirmation]
      @user.password = params[:user][:password]
      @user.reset_password_token = nil
      @user.reset_password_sent_at = nil

      if @user.save
        sign_in(@user)
        redirect_to root_path, notice: "Your password has been updated."
      else
        render :show, status: :unprocessable_entity
      end
    else
      @user.errors.add(:password, "doesn't match confirmation") if params[:user][:password] != params[:user][:password_confirmation]
      @user.errors.add(:password, "can't be blank") if params[:user][:password].blank?
      render :show, status: :unprocessable_entity
    end
  end

  private

  def find_user_by_token
    @user = User.find_by(reset_password_token: params[:id])
    @user = nil if @user&.reset_password_expired?
  end
end
