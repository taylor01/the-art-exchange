class RegistrationsController < ApplicationController
  before_action :redirect_if_signed_in

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)
    @user.email = @user.email&.downcase&.strip

    # Set terms acceptance timestamp and version if checkbox was checked
    if params[:user][:terms_accepted].present? && params[:user][:terms_accepted] != "0"
      @user.terms_accepted_at = Time.current
      @user.terms_version = Rails.application.config.authentication[:current_terms_version]
    end

    if @user.save
      @user.generate_confirmation_token!
      AuthenticationMailer.confirmation_email(@user).deliver_now
      redirect_to confirmation_sent_path, notice: "Please check your email to confirm your account."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def redirect_if_signed_in
    redirect_to root_path if user_signed_in?
  end

  def registration_params
    params.require(:user).permit(:email, :first_name, :last_name, :password)
  end
end
