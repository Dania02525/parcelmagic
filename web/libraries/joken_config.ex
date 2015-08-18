defmodule Joken.Config.Api do
  @behaviour Joken.Config

  def secret_key() do
    "87h8hw8c7nhw0c87njhw0c89j"
  end

  def algorithm() do
    :HS256
  end

  def encode(map) do
    Poison.encode!(map)
  end

  def decode(binary) do
    Poison.decode!(binary)
  end

  def claim(:exp, payload) do
    Joken.Helpers.get_current_time() + 10000
  end

  def claim(_, _) do
    nil
  end

  def validate_claim(:exp, payload, options) do
    Joken.Helpers.validate_time_claim(payload, "exp", "Token expired", fn(expires_at, now) -> expires_at > now end)
  end

  def validate_claim(_, _, _) do
    :ok
  end
end