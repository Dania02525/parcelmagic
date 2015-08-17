defmodule My.Config.Module do
  @behaviour Joken.Config

  def secret_key(), do: "some secret key"

  def algorithm(), do: :HS256

  def encode(map), do: Poison.encode!(map)

  def decode(binary), do: Poison.decode!(binary)

  def claim(:exp, payload) do
    Joken.Helpers.get_current_time() + 300
  end

  def claim(_, _), do: nil

  def validate_claim(:exp, payload, options) do
    Joken.Helpers.validate_time_claim(payload, "exp", "Token expired", fn(expires_at, now) -> expires_at > now end)
  end

  def validate_claim(_, _, _), do: :ok
end