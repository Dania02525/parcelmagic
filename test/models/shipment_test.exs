defmodule Parcelmagic.ShipmentTest do
  use Parcelmagic.ModelCase

  alias Parcelmagic.Shipment

  @valid_attrs %{customs_info: "some content", easypost_id: "some content", from_address: "some content", insurance: "120.5", parcel: "some content", reference: "some content", service: "some content", to_address: "some content"}
  @invalid_attrs %{}

  @valid_buy_attrs %{tracking_code: "some content", carrier: "some content", rate: "120.5", service: "some content", label_url: "some content"}

  test "changeset with valid attributes" do
    changeset = Shipment.changeset(%Shipment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Shipment.changeset(%Shipment{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "buy changeset with valid attributes" do
    changeset = Shipment.buy(%Shipment{}, @valid_buy_attrs)
    assert changeset.valid?
  end

  test "buy changeset with invalid attributes" do
    changeset = Shipment.buy(%Shipment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
