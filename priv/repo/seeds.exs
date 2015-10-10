# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Parcelmagic.Repo.insert!(%SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
Parcelmagic.Repo.insert!(%Parcelmagic.User{email: "dania02525@gmail.com", password: Comeonin.Bcrypt.hashpwsalt("lithic1982")})