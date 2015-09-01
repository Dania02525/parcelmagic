defmodule Parcelmagic.ShipmentController do
  use Parcelmagic.Web, :controller
  use Easypost.Client, endpoint: Application.get_env(:parcelmagic, :easypost_endpoint),                    
                       key: Application.get_env(:parcelmagic, :easypost_key)

  alias Parcelmagic.Shipment
  alias Parcelmagic.Address
  alias Parcelmagic.Parcel

  plug :scrub_params, "shipment" when action in [:create, :update]

  def index(conn, _params) do
    shipments = Repo.all(Shipment)
    render(conn, "index.json", shipments: shipments)
  end

  #this route gets quotes on the shipment
  def getquote(conn, %{"shipment" => shipment_params}) do
    case create_shipment(shipment_params) do
      {:ok, response} ->  
        shipment = response |> Map.put("easypost_id", response["id"]) 

        json conn |> put_status(200), %{"data" => %{"rates" => response["rates"], "shipment" => shipment}}
      {:error, _status, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Parcelmagic.ChangesetView, "error.json", changeset: reason)
    end
  end

  #this route shows an already shipped shipment
  def show(conn, %{"id" => id}) do
    shipment = Repo.get!(Shipment, id)
    render conn, "show.json", shipment: shipment
  end

  #this route buys a shipment rate
  def buy(conn, %{"rate" => rate_params, "shipment" => shipment}) do
    case buy_shipment(rate_params["shipment_id"], %{"id" => rate_params["id"]}) do
      {:ok, response} ->
        IO.inspect response

        from = shipment["From"]
        to = shipment["To"]
        parcel = shipment["Parcel"]
        shipment_params = shipment 
          |> Map.put("tracking_code", response["tracking_code"])
          |> Map.put("carrier", response["selected_rate"]["carrier"])
          |> Map.put("rate", response["selected_rate"]["rate"])
          |> Map.put("service", response["selected_rate"]["service"])
          |> Map.put("label_url", response["postage_label"]["label_url"])

        changesets = [from, to, parcel]
          |> Enum.reject(fn(x)-> x["reference"] == nil end)
          |> Enum.map(fn(x)-> 
            case x["object"] do
              "Address" ->
                Address.changeset(%Address{}, x)
              "Parcel" ->
                Parcel.changeset(%Parcel{}, x)
            end
          end)
          |> List.insert_at(10, Shipment.changeset(%Shipment{}, shipment_params))

        if Enum.all?(changesets, fn(changeset)-> changeset.valid? end) do
          changesets
            |> Enum.map(fn(changeset)-> Task.async(fn()-> Repo.insert!(changeset) end) end)
            |> Enum.map(&Task.await/1)
          json conn |> put_status(200), %{"data" => shipment_params}
        else
          errors = changesets
            |> Enum.map(fn(changeset)-> changeset.errors end)
            |> List.flatten
            |> Enum.reduce(%{}, fn({atom, val}, acc)-> Map.put(acc, Atom.to_string(atom), val) end)
          json conn |> put_status(422), %{"data" => %{"errors" => errors}}
        end
      {:error, _status, reason} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(Parcelmagic.ChangesetView, "error.json", changeset: reason)
    end
  end

  def track(conn, %{"id" => id}) do
    shipment = Repo.get!(Shipment, id)
    case track(%{tracking_code: shipment.tracking_code, carrier: shipment.carrier}) do
      {:ok, response} ->
        tracker = %{
          tracking_code: response["tracking_code"],
          status: response["status"],
          signed_by: response["signed_by"],
          est_delivery_date: response["est_delivery_date"],
          message: response["tracking_details"]["message"],
          last_location: response["tracking_details"]["tracking_location"]["city"] <> " " <> response["tracking_details"]["tracking_location"]["state"]
        }
        render(conn, "tracking.json", tracker: tracker)
      {:error, _status, reason} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(Parcelmagic.ChangesetView, "error.json", changeset: reason)
    end
  end
end
