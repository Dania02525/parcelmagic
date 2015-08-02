defmodule Parcelmagic.PickupTest do
  use Parcelmagic.ModelCase

  alias Parcelmagic.Pickup

  @valid_attrs %{easypost_id: "some content", max_datetime: "some content", pickup_address: "some content", pickup_instructions: "some content", pickup_is_account_address: true, pickup_min_datetime: "some content", pickup_rate: "some content", pickup_reference: "some content", shipment: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Pickup.changeset(%Pickup{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Pickup.changeset(%Pickup{}, @invalid_attrs)
    refute changeset.valid?
  end
end
