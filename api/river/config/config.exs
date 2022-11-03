# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :river,
  ecto_repos: [River.Repo]

# Configures the endpoint
config :river, RiverWeb.Endpoint,
  url: [host: "0.0.0.0"],
  render_errors: [view: RiverWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: River.PubSub,
  live_view: [signing_salt: "ajhJksnal"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :river, River.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :cors_plug,
  origin: ["*"],
  max_age: 86400,
  methods: ["GET", "POST"]

config :river, :jwt_secret, "TkPl4CbRRoHiyVWUN9T8WU3Ymbu39aNpsH3OWi/rxYQoSh06OuEuJmm6OrvqBRZM"

# Mocks
config :river, :jwt, RiverWeb.JWT.Token
config :river, :present_form, River.WorkflowEngine.Steps.PresentForm
config :river, :process_form, River.WorkflowEngine.Steps.ProcessForm
config :river, :redirect, River.WorkflowEngine.Steps.Redirect
config :river, :stop, River.WorkflowEngine.Steps.Stop
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
