use Mix.Config

config :my_app, ecto_repos: [MyApp.Repo]
config :my_app, MyApp.Repo,
       database: "my_app",
       username: "postgres",
       password: "postgres",
       hostname: "localhost"

import_config "#{Mix.env()}.exs"
