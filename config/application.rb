require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ShopifyTest
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Just use local for all environments for the sake of this demo.
    # In reality, we would add another storage config with something like AWS S3 in prod.
    config.active_storage.service = :local

  end
end
