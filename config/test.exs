use Mix.Config

# Configure your database
config :pho, Pho.Repo,
  username: System.get_env("TEST_DB_USER") || "root",
  password: System.get_env("TEST_DB_PASSWORD") || "t",
  database: System.get_env("TEST_DB_NAME") || "pho_test",
  hostname: System.get_env("TEST_DB_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: (System.get_env("DB_POOL_SIZE") || "10") |> Integer.parse() |> elem(0),
  queue_target: 5000

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pho_web, PhoWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
