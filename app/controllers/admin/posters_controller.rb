class Admin::PostersController < ApplicationController
  before_action :ensure_admin
  before_action :set_poster, only: [ :show, :edit, :update, :destroy ]

  def index
    @posters = Poster.includes(:band, :venue, :artists, :series)
                     .chronological
                     .page(params[:page])
                     .per(20)
  end

  def show
  end

  def new
    @poster = Poster.new
    load_form_data
  end

  def create
    @poster = Poster.new(poster_params)

    if @poster.save
      redirect_to admin_poster_path(@poster), notice: "Poster created successfully."
    else
      load_form_data
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    load_form_data
  end

  def update
    if @poster.update(poster_params)
      redirect_to admin_poster_path(@poster), notice: "Poster updated successfully."
    else
      load_form_data
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @poster.destroy
    redirect_to admin_posters_path, notice: "Poster deleted successfully."
  end

  private

  def set_poster
    @poster = Poster.find(params[:id])
  end

  def poster_params
    params.require(:poster).permit(:name, :description, :release_date, :original_price_in_dollars, :edition_size,
                                   :band_id, :venue_id, :image, artist_ids: [], series_ids: [])
  end

  def load_form_data
    @bands = Band.order(:name)
    @venues = Venue.order(:name)
    @artists = Artist.order(:name)
    @series = Series.order(:name)
  end

  def ensure_admin
    redirect_to root_path, alert: "Access denied." unless current_user&.admin?
  end
end
