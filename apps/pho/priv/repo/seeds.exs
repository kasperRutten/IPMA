# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pho.Repo.insert!(%Pho.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
{:ok, _cs} =
  Pho.UserContext.create_user(%{"password" => "t", "role" => "User", "username" => "user", "apiKey" => "aiyuhdyhdihzbiayudiabdn"})

{:ok, _cs} =
  Pho.UserContext.create_user(%{"password" => "t", "role" => "Admin", "username" => "admin", "apiKey" => "aiyuhdyhdihzbiayudiabdn"})