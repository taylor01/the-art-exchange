# frozen_string_literal: true

class PosterMetadataAnalysisJob < ApplicationJob
  # Retry up to 3 times with exponential backoff for API failures
  retry_on StandardError, wait: :polynomially_longer, attempts: 3

  # Don't retry if the poster or image is no longer available
  discard_on ActiveJob::DeserializationError
  discard_on ActiveRecord::RecordNotFound

  def perform(poster)
    return unless poster.image.attached?

    Rails.logger.info "Starting metadata analysis for poster #{poster.id}: #{poster.name}"

    result = PosterMetadataService.analyze_poster(poster)

    if result.present?
      Rails.logger.info "Successfully analyzed poster #{poster.id}"
    else
      Rails.logger.warn "Metadata analysis returned nil for poster #{poster.id}, job will retry if attempts remain"
      raise StandardError, "Analysis failed - will retry"
    end
  end
end
