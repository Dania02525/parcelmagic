defmodule Parcelmagic.PickupController do
  use Parcelmagic.Web, :controller

  alias Parcelmagic.Pickup

  plug :scrub_params, "pickup" when action in [:create, :update]

  def index(conn, _params) do
    pickups = Repo.all(Pickup)
    render(conn, "index.json", pickups: pickups)
  end

  def create(conn, %{"pickup" => pickup_params}) do
    changeset = Pickup.changeset(%Pickup{}, pickup_params)

    case Repo.insert(changeset) do
      {:ok, pickup} ->
        render(conn, "show.json", pickup: pickup)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Parcelmagic.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    pickup = Repo.get!(Pickup, id)
    render conn, "show.json", pickup: pickup
  end

  def update(conn, %{"id" => id, "pickup" => pickup_params}) do
    pickup = Repo.get!(Pickup, id)
    changeset = Pickup.changeset(pickup, pickup_params)

    case Repo.update(changeset) do
      {:ok, pickup} ->
        render(conn, "show.json", pickup: pickup)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Parcelmagic.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    pickup = Repo.get!(Pickup, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    pickup = Repo.delete!(pickup)

    send_resp(conn, :no_content, "")
  end
end
