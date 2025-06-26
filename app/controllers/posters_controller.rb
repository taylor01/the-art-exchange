class PostersController < ApplicationController
  before_action :authenticate_user!, only: [ :add_to_collection, :remove_from_collection ]
  before_action :set_poster, only: [ :show, :add_to_collection, :remove_from_collection ]

  def index
    @search_service = PosterSearchService.new(search_params)
    @posters = @search_service.search
    @facets = @search_service.facet_options

    # Track search analytics
    SearchAnalytic.track_search(
      search_params,
      user: current_user,
      results_count: @posters.respond_to?(:total_count) ? @posters.total_count : @posters.count
    )

    respond_to do |format|
      format.html
      format.json { render json: search_results_json }
    end
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

  def create_search_share
    # Parse JSON body if content type is JSON
    if request.content_type == "application/json"
      parsed_params = JSON.parse(request.body.read)
      search_share = SearchShare.create_for_search(ActionController::Parameters.new(parsed_params).permit(:q, artists: [], venues: [], bands: [], years: []))
    else
      search_share = SearchShare.create_for_search(search_params)
    end

    respond_to do |format|
      format.json do
        render json: {
          url: short_url(search_share.token),
          token: search_share.token
        }
      end
    end
  rescue => e
    Rails.logger.error "Search share error: #{e.message}"
    respond_to do |format|
      format.json { render json: { error: "Failed to create share URL: #{e.message}" }, status: :unprocessable_entity }
    end
  end

  private

  def set_poster
    @poster = Poster.find_by_slug_or_id(params[:id_or_slug])
  end

  def search_params
    params.permit(:q, :page, :per_page, :sort, artists: [], venues: [], bands: [], years: [])
  end

  def short_url(token)
    "#{request.base_url}/s/#{token}"
  end

  def user_poster_params
    params.permit(:status)
  end

  def search_results_json
    {
      posters: @posters.map do |poster|
        {
          id: poster.id,
          name: poster.name,
          band: poster.band&.name,
          venue: poster.venue&.name,
          year: poster.year,
          image_url: poster.image.attached? ? url_for(poster.grid_thumbnail_image_for_display) : nil,
          placeholder_url: poster.image.attached? ? url_for(poster.blur_placeholder_image_for_display) : nil,
          url: poster_path(poster.to_param)
        }
      end,
      facets: @facets,
      pagination: {
        current_page: @posters.respond_to?(:current_page) ? @posters.current_page : 1,
        total_pages: @posters.respond_to?(:total_pages) ? @posters.total_pages : 1,
        total_count: @posters.respond_to?(:total_count) ? @posters.total_count : @posters.count
      }
    }
  end

  def short_url(token)
    "#{request.base_url}/s/#{token}"
  end

  def authenticate_user!
    redirect_to new_session_path, alert: "Please sign in to manage your collection." unless user_signed_in?
  end
end
