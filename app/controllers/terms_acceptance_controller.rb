class TermsAcceptanceController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :ensure_current_terms_accepted

  def show
    @page_title = "Accept Terms of Service"
    @current_terms_version = Rails.application.config.authentication[:current_terms_version]
    @user_terms_version = current_user.terms_version
  end

  def update
    if params[:terms_accepted] == "1"
      current_user.accept_terms!
      flash[:notice] = "Thank you for accepting our Terms of Service."
      redirect_back_or_to(root_path)
    else
      redirect_to terms_acceptance_path, alert: "You must accept the Terms of Service to continue using the platform."
    end
  end
end
