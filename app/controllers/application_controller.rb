class ApplicationController < ActionController::API
  # Required for Serialization - gem active_model_serializers
  include ActionController::Serialization

  # Required for rate limiting and throttling - gem rack-attack
  config.middleware.use Rack::Attack

  # Required for CORS - gem rack-cors
  config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end
end
