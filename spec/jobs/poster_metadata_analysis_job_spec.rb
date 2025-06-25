# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PosterMetadataAnalysisJob, type: :job do
  let(:poster) { create(:poster, :with_image) }
  before do
    # Mock the PosterMetadataService.analyze_poster method to avoid API calls
    allow(PosterMetadataService).to receive(:analyze_poster).and_return({
      "visual" => { "art_style" => "minimalist" }
    })
  end

  it 'queues the job' do
    expect {
      described_class.perform_later(poster)
    }.to have_enqueued_job(described_class).with(poster)
  end

  it 'calls PosterMetadataService.analyze_poster' do
    expect(PosterMetadataService).to receive(:analyze_poster).with(poster).and_call_original

    described_class.perform_now(poster)
  end

  it 'handles poster without image gracefully' do
    poster_without_image = create(:poster)

    expect {
      described_class.perform_now(poster_without_image)
    }.not_to raise_error
  end

  it 'calls the service to analyze the poster' do
    expect(PosterMetadataService).to receive(:analyze_poster).with(poster).and_call_original

    described_class.perform_now(poster)
  end

  it 'is an ApplicationJob' do
    expect(described_class.superclass).to eq(ApplicationJob)
  end
end
