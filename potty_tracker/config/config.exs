# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
import Config

# Configure your database
config :potty_tracker, PottyTracker.Repo,
  username: System.get_env("DATABASE_USER") || "postgres",
  password: System.get_env("DATABASE_PASSWORD") || "postgres",
  hostname: System.get_env("DATABASE_HOST") || "localhost",
  database: System.get_env("DATABASE_NAME") || "potty_tracker_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Configures the endpoint
config :potty_tracker, PottyTrackerWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: PottyTrackerWeb.ErrorHTML, json: PottyTrackerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: PottyTracker.PubSub,
  live_view: [signing_salt: "your-live-view-salt"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.7",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
