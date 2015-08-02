defmodule Parcelmagic.ShipmentControllerTest do
  use Parcelmagic.ConnCase

  alias Parcelmagic.Shipment
  @valid_attrs %{batch_message: "some content", batch_status: "some content", carrier: "some content", customs_info: "some content", easypost_id: "some content", from_address: "some content", insurance: "120.5", options: "some content", parcel: "some content", reference: "some content", refund_status: "some content", return_address: "some content", selected_rate: "some content", service: "some content", to_address: "some content", tracking_code: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, shipment_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    shipment = Repo.insert! %Shipment{}
    conn = get conn, shipment_path(conn, :show, shipment)
    assert json_response(conn, 200)["data"] == %{
      "id" => shipment.id
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, shipment_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, shipment_path(conn, :create), shipment: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Shipment, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, shipment_path(conn, :create), shipment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    shipment = Repo.insert! %Shipment{}
    conn = put conn, shipment_path(conn, :update, shipment), shipment: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Shipment, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    shipment = Repo.insert! %Shipment{}
    conn = put conn, shipment_path(conn, :update, shipment), shipment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    shipment = Repo.insert! %Shipment{}
    conn = delete conn, shipment_path(conn, :delete, shipment)
    assert response(conn, 204)
    refute Repo.get(Shipment, shipment.id)
  end
end
