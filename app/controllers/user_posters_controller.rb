class UserPostersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_poster, only: [ :edit, :update, :destroy ]
  before_action :ensure_owner, only: [ :edit, :update, :destroy ]

  def index
    @owned_posters = current_user.user_posters.owned.includes(:poster)
    @wanted_posters = current_user.user_posters.wanted.includes(:poster)
    @watching_posters = current_user.user_posters.watching.includes(:poster)
  end

  def edit
  end

  def update
    if @user_poster.update(user_poster_params)
      redirect_to poster_path(@user_poster.poster), notice: "Collection item updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    poster_name = @user_poster.poster.name
    @user_poster.destroy
    redirect_to user_posters_path, notice: "Removed #{poster_name} from your collection."
  end

  private

  def set_user_poster
    @user_poster = UserPoster.find(params[:id])
  end

  def ensure_owner
    redirect_to user_posters_path, alert: "Access denied." unless @user_poster.user == current_user
  end

  def user_poster_params
    params.require(:user_poster).permit(:status, :edition_number, :notes, :purchase_price,
                                        :purchase_date, :condition, :for_sale, :asking_price,
                                        images: [])
  end

  def authenticate_user!
    redirect_to new_session_path, alert: "Please sign in to access your collection." unless user_signed_in?
  end
end
