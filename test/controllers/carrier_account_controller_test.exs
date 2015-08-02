defmodule Parcelmagic.CarrierAccountControllerTest do
  use Parcelmagic.ConnCase

  alias Parcelmagic.CarrierAccount
  @valid_attrs %{description: "some content", easypost_id: "some content", logo: "some content", readable: "some content", reference: "some content", type: "some content"}
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
      "id" => carrier_account.id
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, carrier_account_path(conn, :show, -1)
    end
  end

  #not testing create/update resources as its not possible with test api key

  test "deletes chosen resource", %{conn: conn} do
    carrier_account = Repo.insert! %CarrierAccount{}
    conn = delete conn, carrier_account_path(conn, :delete, carrier_account)
    assert response(conn, 204)
    refute Repo.get(CarrierAccount, carrier_account.id)
  end
end
