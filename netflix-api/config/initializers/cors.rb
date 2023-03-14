Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'

    resource '*',
      headers: :any,
      methods: %i[get post put patch delete options head],
      expose: %w[access-token client expiry token-type uid exp]
  end
end
