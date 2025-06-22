class OmniauthCallbacksController < ApplicationController
  def google_oauth2
    handle_omniauth("Google")
  end

  def facebook
    handle_omniauth("Facebook")
  end

  def apple
    handle_omniauth("Apple")
  end

  def failure
    redirect_to new_session_path, alert: "Authentication failed: #{params[:message]}"
  end

  private

  def handle_omniauth(provider_name)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in(@user)
      redirect_back_or_to(root_path)
    else
      session[:omniauth_data] = request.env["omniauth.auth"].except("extra")
      redirect_to new_registration_path, alert: "Unable to sign in with #{provider_name}. Please create an account manually."
    end
  end
end
