defmodule Parcelmagic.CustomsInfoControllerTest do
  use Parcelmagic.ConnCase

  alias Parcelmagic.CustomsInfo
  @valid_attrs %{contents_explanation: "some content", contents_type: "some content", customs_certify: true, easypost_id: "some content", non_delivery_option: "some content", restriction_comments: "some content", restriction_type: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, customs_info_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    customs_info = Repo.insert! %CustomsInfo{}
    conn = get conn, customs_info_path(conn, :show, customs_info)
    assert json_response(conn, 200)["data"] == %{
      "id" => customs_info.id
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, customs_info_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, customs_info_path(conn, :create), customs_info: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(CustomsInfo, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, customs_info_path(conn, :create), customs_info: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    customs_info = Repo.insert! %CustomsInfo{}
    conn = put conn, customs_info_path(conn, :update, customs_info), customs_info: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(CustomsInfo, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    customs_info = Repo.insert! %CustomsInfo{}
    conn = put conn, customs_info_path(conn, :update, customs_info), customs_info: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    customs_info = Repo.insert! %CustomsInfo{}
    conn = delete conn, customs_info_path(conn, :delete, customs_info)
    assert response(conn, 204)
    refute Repo.get(CustomsInfo, customs_info.id)
  end
end
