defmodule Parcelmagic.ShipmentTest do
  use Parcelmagic.ModelCase

  alias Parcelmagic.Shipment

  @valid_attrs %{batch_message: "some content", batch_status: "some content", carrier: "some content", customs_info: "some content", easypost_id: "some content", from_address: "some content", insurance: "120.5", options: "some content", parcel: "some content", reference: "some content", refund_status: "some content", return_address: "some content", selected_rate: "some content", service: "some content", to_address: "some content", tracking_code: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Shipment.changeset(%Shipment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Shipment.changeset(%Shipment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
