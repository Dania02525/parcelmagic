defmodule Parcelmagic.PickupControllerTest do
  use Parcelmagic.ConnCase

  alias Parcelmagic.Pickup
  @valid_attrs %{easypost_id: "some content", max_datetime: "some content", pickup_address: "some content", pickup_instructions: "some content", pickup_is_account_address: true, pickup_min_datetime: "some content", pickup_rate: "some content", pickup_reference: "some content", shipment: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, pickup_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    pickup = Repo.insert! %Pickup{}
    conn = get conn, pickup_path(conn, :show, pickup)
    assert json_response(conn, 200)["data"] == %{
      "id" => pickup.id
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, pickup_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, pickup_path(conn, :create), pickup: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Pickup, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, pickup_path(conn, :create), pickup: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    pickup = Repo.insert! %Pickup{}
    conn = put conn, pickup_path(conn, :update, pickup), pickup: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Pickup, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    pickup = Repo.insert! %Pickup{}
    conn = put conn, pickup_path(conn, :update, pickup), pickup: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    pickup = Repo.insert! %Pickup{}
    conn = delete conn, pickup_path(conn, :delete, pickup)
    assert response(conn, 204)
    refute Repo.get(Pickup, pickup.id)
  end
end
