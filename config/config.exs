# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :friend_garden,
  ecto_repos: [FriendGarden.Repo]

# Configures the endpoint
config :friend_garden, FriendGarden.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4h9Vn2PfnqkSKKJL72qYOWxZhjDtWpQaJsY0rvQ8DWi6zItOnor+xH1EidHFMsQS",
  render_errors: [view: FriendGarden.ErrorView, accepts: ~w(html json)],
  pubsub: [name: FriendGarden.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :addict,
  secret_key: "24326224313224314142696f6e672f6d33504b4856467a6f694b4f6375",
  extra_validation: fn ({valid, errors}, user_params) -> {valid, errors} end, # define extra validation here
  user_schema: FriendGarden.User,
  repo: FriendGarden.Repo,
  from_email: "no-reply@example.com", # CHANGE THIS
mail_service: nil