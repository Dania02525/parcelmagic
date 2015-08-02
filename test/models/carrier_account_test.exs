defmodule Parcelmagic.CarrierAccountTest do
  use Parcelmagic.ModelCase

  alias Parcelmagic.CarrierAccount

  @valid_attrs %{credentials: "some content", description: "some content", easypost_id: "some content", logo: "some content", readable: "some content", reference: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CarrierAccount.changeset(%CarrierAccount{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CarrierAccount.changeset(%CarrierAccount{}, @invalid_attrs)
    refute changeset.valid?
  end
end
