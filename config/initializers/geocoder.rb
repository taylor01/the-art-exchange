Geocoder.configure(
  timeout: 3,
  lookup: :mapbox,
  api_key: ENV["MAPBOX_API_KEY"],
  language: :en,
  use_https: true,
  http_proxy: nil,
  https_proxy: nil,
  cache: nil,
  cache_prefix: "geocoder:",
  always_raise: [],
  units: :km,
  distances: :linear
)