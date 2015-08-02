defmodule Parcelmagic.CarrierAccountControllerTest do
  use Parcelmagic.ConnCase
  ExUnit.configure exclude: [production_only: true]

  alias Parcelmagic.CarrierAccount
  @valid_attrs %{credentials: "some content", description: "some content", easypost_id: "some content", logo: "some content", readable: "some content", reference: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, carrier_account_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    carrier_account = Repo.insert! %CarrierAccount{}
    conn = get conn, carrier_account_path(conn, :show, carrier_account)
    assert json_response(conn, 200)["data"] == %{
      "id" => carrier_account.id,
      "easypost_id" => carrier_account.easypost_id,
      "reference" => carrier_account.reference,
      "description" => carrier_account.description,
      "credentials" => carrier_account.credentials,
      "logo" => carrier_account.logo,
      "readable" => carrier_account.readable,
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, carrier_account_path(conn, :show, -1)
    end
  end

  @tag: :production_only
  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, carrier_account_path(conn, :create), carrier_account: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(CarrierAccount, @valid_attrs)
  end

  @tag: :production_only
  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, carrier_account_path(conn, :create), carrier_account: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  @tag: :production_only
  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    carrier_account = Repo.insert! %CarrierAccount{}
    conn = put conn, carrier_account_path(conn, :update, carrier_account), carrier_account: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(CarrierAccount, @valid_attrs)
  end

  @tag: :production_only
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    carrier_account = Repo.insert! %CarrierAccount{}
    conn = put conn, carrier_account_path(conn, :update, carrier_account), carrier_account: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    carrier_account = Repo.insert! %CarrierAccount{}
    conn = delete conn, carrier_account_path(conn, :delete, carrier_account)
    assert response(conn, 204)
    refute Repo.get(CarrierAccount, carrier_account.id)
  end
end
