class ShowsController < ApplicationController
  before_action :set_show, only: [:show]

  def index
    @shows = Show.includes(:band, :venue, :setlist_songs, :songs)
                 .order(show_date: :desc)
                 .page(params[:page])
                 .per(20)

    # Optional filtering
    @shows = @shows.joins(:band).where("bands.name ILIKE ?", "%#{params[:band]}%") if params[:band].present?
    @shows = @shows.joins(:venue).where("venues.name ILIKE ?", "%#{params[:venue]}%") if params[:venue].present?
    @shows = @shows.where("EXTRACT(year FROM show_date) = ?", params[:year]) if params[:year].present?

    respond_to do |format|
      format.html
      format.json { render json: shows_json }
    end
  end

  def show
    @setlist_songs = @show.setlist_songs.includes(:song).order(:set_type, :position)
    @venue = @show.venue
    @band = @show.band
    # Find related posters - both directly linked and from same venue/band/timeframe
    @posters = Poster.joins(:band, :venue)
                    .where(bands: { id: @show.band_id }, venues: { id: @show.venue_id })
                    .where('EXTRACT(year FROM release_date) = ? OR release_date IS NULL', @show.show_date.year)
                    .includes(:artists)
    
    # Group songs by set type
    @sets = @setlist_songs.group_by(&:set_type)
  end

  private

  def set_show
    @show = Show.includes(:band, :venue, :setlist_songs, :songs).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to shows_path, alert: "Show not found."
  end

  def shows_json
    {
      shows: @shows.map do |show|
        {
          id: show.id,
          band: show.band.name,
          venue: show.venue.name,
          date: show.show_date.strftime("%B %d, %Y"),
          location: show.venue.location_summary,
          song_count: show.setlist_songs.count,
          url: show_path(show)
        }
      end,
      pagination: {
        current_page: @shows.current_page,
        total_pages: @shows.total_pages,
        total_count: @shows.total_count
      }
    }
  end
end