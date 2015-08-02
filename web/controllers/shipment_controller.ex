defmodule Parcelmagic.ShipmentController do
  use Parcelmagic.Web, :controller

  alias Parcelmagic.Shipment

  plug :scrub_params, "shipment" when action in [:create, :update]

  def index(conn, _params) do
    shipments = Repo.all(Shipment)
    render(conn, "index.json", shipments: shipments)
  end

  def create(conn, %{"shipment" => shipment_params}) do
    changeset = Shipment.changeset(%Shipment{}, shipment_params)

    case Repo.insert(changeset) do
      {:ok, shipment} ->
        render(conn, "show.json", shipment: shipment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Parcelmagic.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    shipment = Repo.get!(Shipment, id)
    render conn, "show.json", shipment: shipment
  end

  def update(conn, %{"id" => id, "shipment" => shipment_params}) do
    shipment = Repo.get!(Shipment, id)
    changeset = Shipment.changeset(shipment, shipment_params)

    case Repo.update(changeset) do
      {:ok, shipment} ->
        render(conn, "show.json", shipment: shipment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Parcelmagic.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    shipment = Repo.get!(Shipment, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    shipment = Repo.delete!(shipment)

    send_resp(conn, :no_content, "")
  end
end
