# Configure Solid Cache to use the primary database connection
# instead of trying to connect to a separate cache database
if Rails.env.production?
  Rails.application.configure do
    # Use the primary database for Solid Cache
    config.solid_cache.connects_to = nil
  end
end