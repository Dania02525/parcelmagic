defmodule Parcelmagic.AddressController do
  use Parcelmagic.Web, :controller
  use Easypost.Client, endpoint: Application.get_env(:parcelmagic, :easypost_endpoint),                    
                       key: Application.get_env(:parcelmagic, :easypost_key)

  alias Parcelmagic.Address

  plug :scrub_params, "address" when action in [:create, :update]

  def index(conn, _params) do
    addresses = Repo.all(Address)
    render(conn, "index.json", addresses: addresses)
  end

  def create(conn, %{"address" => address_params}) do
    case create_address(address_params) do
      {:ok, response} ->  
        address_params = response |> Map.put("easypost_id", response["id"])
        changeset = Address.changeset(%Address{}, address_params)

        case Repo.insert(changeset) do
          {:ok, address} ->
            render(conn, "show.json", address: address)
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
    address = Repo.get!(Address, id)
    render conn, "show.json", address: address
  end

  def update(conn, %{"id" => id, "address" => address_params}) do
    case create_address(address_params) do
      {:ok, response} -> 
        address_params = response |> Map.put("easypost_id", response["id"])
        address = Repo.get!(Address, id)
        changeset = Address.changeset(address, address_params)

        case Repo.update(changeset) do
          {:ok, address} ->
            render(conn, "show.json", address: address)
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
    address = Repo.get!(Address, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    address = Repo.delete!(address)

    send_resp(conn, :no_content, "")
  end
end
