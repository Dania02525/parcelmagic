defmodule Parcelmagic.CustomsInfoController do
  use Parcelmagic.Web, :controller

  alias Parcelmagic.CustomsInfo

  plug :scrub_params, "customs_info" when action in [:create, :update]

  def index(conn, _params) do
    customs_infos = Repo.all(CustomsInfo)
    render(conn, "index.json", customs_infos: customs_infos)
  end

  def create(conn, %{"customs_info" => customs_info_params}) do
    changeset = CustomsInfo.changeset(%CustomsInfo{}, customs_info_params)

    case Repo.insert(changeset) do
      {:ok, customs_info} ->
        render(conn, "show.json", customs_info: customs_info)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Parcelmagic.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    customs_info = Repo.get!(CustomsInfo, id)
    render conn, "show.json", customs_info: customs_info
  end

  def update(conn, %{"id" => id, "customs_info" => customs_info_params}) do
    customs_info = Repo.get!(CustomsInfo, id)
    changeset = CustomsInfo.changeset(customs_info, customs_info_params)

    case Repo.update(changeset) do
      {:ok, customs_info} ->
        render(conn, "show.json", customs_info: customs_info)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Parcelmagic.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    customs_info = Repo.get!(CustomsInfo, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    customs_info = Repo.delete!(customs_info)

    send_resp(conn, :no_content, "")
  end
end
