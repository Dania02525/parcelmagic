defmodule Parcelmagic.Repo do
  use Ecto.Repo, otp_app: :parcelmagic, extensions: [{Postgrex.Extensions.JSON, library: Poison}]
end
