defmodule Parcelmagic.CarrierAccountController do
  use Parcelmagic.Web, :controller
  use Easypost.Client, endpoint: Application.get_env(:parcelmagic, :easypost_endpoint),                    
                       key: Application.get_env(:parcelmagic, :easypost_key)


  alias Parcelmagic.CarrierAccount

  plug :scrub_params, "carrier_account" when action in [:create, :update]

  def index(conn, _params) do
    carrier_accounts = Repo.all(CarrierAccount)
    render(conn, "index.json", carrier_accounts: carrier_accounts)
  end

  def create(conn, %{"carrier_account" => carrier_account_params}) do
    case add_carrier_account(carrier_account_params) do
      {:ok, response} ->
        carrier_account_params = response |> Map.put("easypost_id", response["id"])
        changeset = CarrierAccount.changeset(%CarrierAccount{}, carrier_account_params)

        case Repo.insert(changeset) do
          {:ok, carrier_account} ->
            render(conn, "show.json", carrier_account: carrier_account)
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
    carrier_account = Repo.get!(CarrierAccount, id)
    render conn, "show.json", carrier_account: carrier_account
  end

  def update(conn, %{"id" => id, "carrier_account" => carrier_account_params}) do
    case add_carrier_account(carrier_account_params) do
      {:ok, response} ->
        carrier_account_params = response |> Map.put("easypost_id", response["id"])
        carrier_account = Repo.get!(CarrierAccount, id)
        changeset = CarrierAccount.changeset(carrier_account, carrier_account_params)

        case Repo.update(changeset) do
          {:ok, carrier_account} ->
            render(conn, "show.json", carrier_account: carrier_account)
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
    carrier_account = Repo.get!(CarrierAccount, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    carrier_account = Repo.delete!(carrier_account)

    send_resp(conn, :no_content, "")
  end
end
