class PostersController < ApplicationController
  before_action :authenticate_user!, only: [ :add_to_collection, :remove_from_collection ]
  before_action :set_poster, only: [ :show, :add_to_collection, :remove_from_collection ]

  def index
    @posters = Poster.includes(:band, :venue, :artists)
                     .chronological
                     .page(params[:page])
                     .per(20)
  end

  def show
    @user_posters = current_user&.user_posters&.by_poster(@poster) || []
    @for_sale_copies = @poster.user_posters.for_sale.includes(:user)
  end

  def add_to_collection
    @user_poster = current_user.user_posters.build(
      poster: @poster,
      status: user_poster_params[:status] || "watching"
    )

    if @user_poster.save
      redirect_to poster_path(@poster), notice: "Added #{@poster.name} to your collection as #{@user_poster.status.humanize}."
    else
      redirect_to poster_path(@poster), alert: "Could not add poster to collection: #{@user_poster.errors.full_messages.join(', ')}"
    end
  end

  def remove_from_collection
    @user_poster = current_user.user_posters.find(params[:user_poster_id])
    @user_poster.destroy
    redirect_to poster_path(@poster), notice: "Removed #{@poster.name} from your collection."
  end

  private

  def set_poster
    @poster = Poster.find(params[:id])
  end

  def user_poster_params
    params.permit(:status)
  end

  def authenticate_user!
    redirect_to new_session_path, alert: "Please sign in to manage your collection." unless user_signed_in?
  end
end
