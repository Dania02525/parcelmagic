defmodule Parcelmagic.CustomsItemControllerTest do
  use Parcelmagic.ConnCase

  alias Parcelmagic.CustomsItem
  @valid_attrs %{description: "some content", easypost_id: "some content", hs_tariff_number: "some content", origin_country: "some content", quantity: 42, value: "120.5", weight: "120.5"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, customs_item_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    customs_item = Repo.insert! %CustomsItem{}
    conn = get conn, customs_item_path(conn, :show, customs_item)
    assert json_response(conn, 200)["data"] == %{
      "id" => customs_item.id
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, customs_item_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, customs_item_path(conn, :create), customs_item: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(CustomsItem, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, customs_item_path(conn, :create), customs_item: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    customs_item = Repo.insert! %CustomsItem{}
    conn = put conn, customs_item_path(conn, :update, customs_item), customs_item: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(CustomsItem, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    customs_item = Repo.insert! %CustomsItem{}
    conn = put conn, customs_item_path(conn, :update, customs_item), customs_item: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    customs_item = Repo.insert! %CustomsItem{}
    conn = delete conn, customs_item_path(conn, :delete, customs_item)
    assert response(conn, 204)
    refute Repo.get(CustomsItem, customs_item.id)
  end
end
