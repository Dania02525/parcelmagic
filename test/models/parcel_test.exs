defmodule Parcelmagic.ParcelTest do
  use Parcelmagic.ModelCase

  alias Parcelmagic.Parcel

  @valid_attrs %{reference: "some content", easypost_id: "some content", height: "120.5", length: "120.5", weight: "120.5", width: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Parcel.changeset(%Parcel{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Parcel.changeset(%Parcel{}, @invalid_attrs)
    refute changeset.valid?
  end
end
