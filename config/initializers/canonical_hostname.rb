if ENV['CANONICAL_HOSTNAME'].present?
  Rails.application.config.middleware.insert_before(
    0,
    Rack::CanonicalHost,
    ENV['CANONICAL_HOSTNAME']
  )
end
