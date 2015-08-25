defmodule Parcelmagic.AddressTest do
  use Parcelmagic.ModelCase

  alias Parcelmagic.Address

  @valid_attrs %{reference: "some content", city: "some content", company: "some content", country: "some content", easypost_id: "some content", email: "some content", name: "some content", phone: "some content", state: "some content", street1: "some content", street2: "some content", zip: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Address.changeset(%Address{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Address.changeset(%Address{}, @invalid_attrs)
    refute changeset.valid?
  end
end
