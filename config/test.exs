import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :about, AboutWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "zV4LXLqOETAMga4SMlNh+mLloM72qiN3TDv3DK1ocjXWdZqnXs563e3jc9yuztYI",
  server: false

# In test we don't send emails.
config :about, About.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
