defmodule Parcelmagic.CustomsInfoTest do
  use Parcelmagic.ModelCase

  alias Parcelmagic.CustomsInfo

  @valid_attrs %{contents_explanation: "some content", contents_type: "some content", customs_certify: true, easypost_id: "some content", non_delivery_option: "some content", restriction_comments: "some content", restriction_type: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CustomsInfo.changeset(%CustomsInfo{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CustomsInfo.changeset(%CustomsInfo{}, @invalid_attrs)
    refute changeset.valid?
  end
end
