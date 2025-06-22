class ConfirmationsController < ApplicationController
  def show
    @user = User.find_by(confirmation_token: params[:token])

    if @user && !@user.confirmation_expired?
      @user.confirm!
      sign_in(@user)
      redirect_to root_path, notice: "Your email has been confirmed! Welcome to The Art Exchange."
    elsif @user&.confirmation_expired?
      redirect_to resend_confirmation_path(email: @user.email), alert: "Confirmation link has expired. We'll send you a new one."
    else
      redirect_to root_path, alert: "Invalid confirmation link."
    end
  end

  def new
    @email = params[:email]
  end

  def create
    @user = User.find_by(email: params[:email]&.downcase&.strip)

    if @user && !@user.confirmed?
      @user.generate_confirmation_token!
      AuthenticationMailer.confirmation_email(@user).deliver_now
      redirect_to confirmation_sent_path, notice: "Confirmation email has been resent."
    else
      @email = params[:email]
      render :new, alert: "Email not found or already confirmed."
    end
  end

  def sent
    # Just renders the confirmation sent page
  end
end
