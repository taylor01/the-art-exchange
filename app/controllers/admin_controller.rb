class AdminController < ApplicationController
  before_action :ensure_admin

  def index
  end

  private

  def ensure_admin
    redirect_to root_path, alert: "Access denied." unless current_user&.admin?
  end
end
