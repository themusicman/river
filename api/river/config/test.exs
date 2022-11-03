import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
if config_env() == :test do
  config :river, River.Repo,
    # database: "river_test#{System.get_env("MIX_TEST_PARTITION")}",
    url: "postgres://postgres@db:5432/river_test",
    pool: Ecto.Adapters.SQL.Sandbox,
    pool_size: 10

  config :river,
         :ui_host,
         "http://localhost:3000"

  config :river,
         :api_host,
         "http://localhost:4000"
end

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :river, RiverWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "YJpkGoRRXomS1V8e+HxImTnAIRCM9k/e7OZUGC9wN6f9mOf6KZXWNSLz+63sV6Fg",
  server: false

# In test we don't send emails.
config :river, River.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Mocks
config :river, :jwt, RiverWeb.JWT.TokenMock

config :river, :basic_auth, {"testkey", "testsecret"}

config :river, :environment, :test
