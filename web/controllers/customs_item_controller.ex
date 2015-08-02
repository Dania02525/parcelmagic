defmodule Parcelmagic.CustomsItemController do
  use Parcelmagic.Web, :controller

  alias Parcelmagic.CustomsItem

  plug :scrub_params, "customs_item" when action in [:create, :update]

  def index(conn, _params) do
    customs_items = Repo.all(CustomsItem)
    render(conn, "index.json", customs_items: customs_items)
  end

  def create(conn, %{"customs_item" => customs_item_params}) do
    changeset = CustomsItem.changeset(%CustomsItem{}, customs_item_params)

    case Repo.insert(changeset) do
      {:ok, customs_item} ->
        render(conn, "show.json", customs_item: customs_item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Parcelmagic.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    customs_item = Repo.get!(CustomsItem, id)
    render conn, "show.json", customs_item: customs_item
  end

  def update(conn, %{"id" => id, "customs_item" => customs_item_params}) do
    customs_item = Repo.get!(CustomsItem, id)
    changeset = CustomsItem.changeset(customs_item, customs_item_params)

    case Repo.update(changeset) do
      {:ok, customs_item} ->
        render(conn, "show.json", customs_item: customs_item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Parcelmagic.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    customs_item = Repo.get!(CustomsItem, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    customs_item = Repo.delete!(customs_item)

    send_resp(conn, :no_content, "")
  end
end
