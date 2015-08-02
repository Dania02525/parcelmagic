defmodule Parcelmagic.ParcelController do
  use Parcelmagic.Web, :controller
  use Easypost.Client, endpoint: Application.get_env(:parcelmagic, :easypost_endpoint),                    
                       key: Application.get_env(:parcelmagic, :easypost_key)

  alias Parcelmagic.Parcel

  plug :scrub_params, "parcel" when action in [:create, :update]

  def index(conn, _params) do
    parcels = Repo.all(Parcel)
    render(conn, "index.json", parcels: parcels)
  end

  def create(conn, %{"parcel" => parcel_params}) do
    case create_parcel(parcel_params) do
      {:ok, response} ->  
        parcel_params = response |> Map.put("easypost_id", response["id"])
        changeset = Parcel.changeset(%Parcel{}, parcel_params)

        case Repo.insert(changeset) do
          {:ok, parcel} ->
            render(conn, "show.json", parcel: parcel)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(Parcelmagic.ChangesetView, "error.json", changeset: changeset)
        end
      {:error, _status, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Parcelmagic.ChangesetView, "error.json", changeset: reason)
    end
  end

  def show(conn, %{"id" => id}) do
    parcel = Repo.get!(Parcel, id)
    render conn, "show.json", parcel: parcel
  end

  def update(conn, %{"id" => id, "parcel" => parcel_params}) do
    case create_parcel(parcel_params) do
      {:ok, response} ->  
        parcel_params = response |> Map.put("easypost_id", response["id"])
        parcel = Repo.get!(Parcel, id)
        changeset = Parcel.changeset(parcel, parcel_params)

        case Repo.update(changeset) do
          {:ok, parcel} ->
            render(conn, "show.json", parcel: parcel)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(Parcelmagic.ChangesetView, "error.json", changeset: changeset)
        end
      {:error, _status, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Parcelmagic.ChangesetView, "error.json", changeset: reason)
    end
  end

  def delete(conn, %{"id" => id}) do
    parcel = Repo.get!(Parcel, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    parcel = Repo.delete!(parcel)

    send_resp(conn, :no_content, "")
  end
end
