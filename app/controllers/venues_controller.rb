class VenuesController < ApplicationController
  before_action :set_venue, only: [:show]

  def index
    @venues = Venue.includes(:shows, :posters, :claude_venue_consultations, :venue_names)
                   .order(:name)

    # Apply search filter if provided
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @venues = @venues.where(
        "venues.name ILIKE ? OR venues.city ILIKE ? OR venues.administrative_area ILIKE ?",
        search_term, search_term, search_term
      )
    end

    # Apply location filter if provided
    if params[:location].present?
      location_term = "%#{params[:location]}%"
      @venues = @venues.where(
        "venues.city ILIKE ? OR venues.administrative_area ILIKE ?",
        location_term, location_term
      )
    end

    # Apply Claude status filter if provided
    case params[:claude_status]
    when 'matched'
      @venues = @venues.where(claude_matched: true)
    when 'unmatched'
      @venues = @venues.where(claude_matched: false)
    when 'consulted'
      @venues = @venues.joins(:claude_venue_consultations)
    end

    # Apply research status filter if provided
    if params[:research_status].present?
      @venues = @venues.where(research_status: params[:research_status])
    end

    @venues = @venues.page(params[:page]).per(50)
    
    # Stats for the header
    @total_venues = Venue.count
    @claude_matched = Venue.where(claude_matched: true).count
    @claude_consulted = Venue.joins(:claude_venue_consultations).distinct.count
    @research_completed = Venue.where(research_status: 'completed').count
    @research_pending = Venue.where(research_status: 'pending').count
    @research_failed = Venue.where(research_status: 'failed').count
  end

  def show
    @shows = @venue.shows.includes(:band, :setlist_songs => :song).order(:show_date)
    @posters = @venue.posters.order(:release_date)
    @consultations = @venue.claude_venue_consultations.order(:created_at)
    @venue_names = @venue.venue_names.order(:start_date)
  end

  private

  def set_venue
    @venue = Venue.find(params[:id])
  end
end