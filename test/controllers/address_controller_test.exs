defmodule Parcelmagic.AddressControllerTest do
  use Parcelmagic.ConnCase

  alias Parcelmagic.Address
  @valid_attrs %{city: "some content", company: "some content", country: "some content", easypost_id: "some content", email: "some content", name: "some content", phone: "some content", state: "some content", street1: "some content", street2: "some content", zip: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, address_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    address = Repo.insert! %Address{}
    conn = get conn, address_path(conn, :show, address)
    assert json_response(conn, 200)["data"] == %{
      "id" => address.id,
      "easypost_id" => address.easypost_id,
      "name" => address.name,
      "company" => address.company,
      "street1" => address.street1,
      "street2" => address.street2,
      "city" => address.city,
      "state" => address.state,
      "zip" => address.zip,
      "country" => address.country,
      "phone" => address.phone,
      "email" => address.email
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, address_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, address_path(conn, :create), address: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Address, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, address_path(conn, :create), address: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    address = Repo.insert! %Address{}
    conn = put conn, address_path(conn, :update, address), address: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Address, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    address = Repo.insert! %Address{}
    conn = put conn, address_path(conn, :update, address), address: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    address = Repo.insert! %Address{}
    conn = delete conn, address_path(conn, :delete, address)
    assert response(conn, 204)
    refute Repo.get(Address, address.id)
  end
end
