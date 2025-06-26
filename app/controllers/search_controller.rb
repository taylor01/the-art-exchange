# frozen_string_literal: true

class SearchController < ApplicationController
  def show
    @search_share = SearchShare.active.find_by(token: params[:token])

    if @search_share
      redirect_to posters_path(@search_share.parsed_params)
    else
      redirect_to posters_path, alert: "Search link not found or expired."
    end
  end
end
