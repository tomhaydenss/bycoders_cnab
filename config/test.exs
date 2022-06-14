import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :bycoders_cnab, BycodersCnab.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "bycoders_cnab_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bycoders_cnab, BycodersCnabWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "DKg0LiYBWKtZyIie8OFait3b/Exl01KF+6lZylIWjscNylJJ1UVdRrCd9gzN18JI",
  server: false

# In test we don't send emails.
config :bycoders_cnab, BycodersCnab.Mailer, adapter: Swoosh.Adapters.Test

config :logger, :console, level: :warn
config :logger, level: :info

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :bycoders_cnab, :cnab_parser, BycodersCnab.Parser.CNABParserMock
