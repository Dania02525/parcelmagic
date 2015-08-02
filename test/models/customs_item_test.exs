defmodule Parcelmagic.CustomsItemTest do
  use Parcelmagic.ModelCase

  alias Parcelmagic.CustomsItem

  @valid_attrs %{description: "some content", easypost_id: "some content", hs_tariff_number: "some content", origin_country: "some content", quantity: 42, value: "120.5", weight: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CustomsItem.changeset(%CustomsItem{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CustomsItem.changeset(%CustomsItem{}, @invalid_attrs)
    refute changeset.valid?
  end
end
