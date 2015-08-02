defmodule Parcelmagic.ParcelControllerTest do
  use Parcelmagic.ConnCase

  alias Parcelmagic.Parcel
  @valid_attrs %{easypost_id: "some content", height: "120.5", length: "120.5", weight: "120.5", width: "120.5"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, parcel_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    parcel = Repo.insert! %Parcel{}
    conn = get conn, parcel_path(conn, :show, parcel)
    assert json_response(conn, 200)["data"] == %{
      "id" => parcel.id
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, parcel_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, parcel_path(conn, :create), parcel: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Parcel, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, parcel_path(conn, :create), parcel: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    parcel = Repo.insert! %Parcel{}
    conn = put conn, parcel_path(conn, :update, parcel), parcel: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Parcel, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    parcel = Repo.insert! %Parcel{}
    conn = put conn, parcel_path(conn, :update, parcel), parcel: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    parcel = Repo.insert! %Parcel{}
    conn = delete conn, parcel_path(conn, :delete, parcel)
    assert response(conn, 204)
    refute Repo.get(Parcel, parcel.id)
  end
end
