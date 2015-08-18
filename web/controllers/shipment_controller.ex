defmodule Parcelmagic.ShipmentController do
  use Parcelmagic.Web, :controller
  use Easypost.Client, endpoint: Application.get_env(:parcelmagic, :easypost_endpoint),                    
                       key: Application.get_env(:parcelmagic, :easypost_key)

  alias Parcelmagic.Shipment

  plug :scrub_params, "shipment" when action in [:create, :update]

  def index(conn, _params) do
    shipments = Repo.all(Shipment)
    render(conn, "index.json", shipments: shipments)
  end

  #this route gets quotes on the shipment
  def create(conn, %{"shipment" => shipment_params}) do
    case create_shipment(shipment_params) do
      {:ok, response} ->  
        shipment_params = response |> Map.put("easypost_id", response["id"])
        changeset = Shipment.changeset(%Shipment{}, shipment_params)

        case Repo.insert(changeset) do
          {:ok, shipment} ->
            rates = Enum.map(response["rates"], fn(x)-> Map.put(x, "easypost_id", x["id"]) end)
                    |> Enum.map(fn(x)-> Map.put(x, "shipment_easypost_id", x["shipment_id"]) end)
                    |> Enum.map(fn(x)-> Map.put(x, "shipment_id", shipment.id) end)                   
            json conn |> put_status(200), %{"data" => rates}
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
    shipment = Repo.get!(Shipment, id)
    render conn, "show.json", shipment: shipment
  end

  #this route updates shipments not yet purchased to get new rates
  def update(conn, %{"id" => id, "shipment" => shipment_params}) do
    shipment = Repo.get!(Shipment, id)
    if shipment.tracking_code != nil do
      conn
        |> put_status(:unprocessable_entity)
        |> render(Parcelmagic.ChangesetView, "error.json", changeset: "Cannot update already purchased shipment")
    else
      case create_shipment(shipment_params) do
        {:ok, response} ->  
          shipment_params = response |> Map.put("easypost_id", response["id"])
          changeset = Shipment.changeset(shipment, shipment_params)

          case Repo.update(changeset) do
            {:ok, shipment} ->
              rates = Enum.map(response["rates"], fn(x)-> Map.put(x, "easypost_id", x["id"]) end)
                      |> Enum.map(fn(x)-> Map.put(x, "shipment_easypost_id", x["shipment_id"]) end)
                      |> Enum.map(fn(x)-> Map.put(x, "shipment_id", shipment.id) end)
                      |> Enum.map(fn({k,v})-> {String.to_atom(k), v} end)                    
              render(conn, "quotes.json", rates: rates)
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
  end

  def buy(conn, %{"rate" => rate_params}) do
    shipment = Repo.get!(Shipment, rate_params["shipment_id"])
    case buy_shipment(rate_params["easypost_shipment_id"], %{id: rate_params["id"]}) do
      {:ok, response} ->
        shipment_params = %{ 
          "tracking_code" => response["tracking_code"], 
          "carrier" => response["selected_rate"]["carrier"],
          "rate" => response["selected_rate"]["rate"],
          "service" => response["selected_rate"]["service"],
          "label_url" => response["label_pdf_url"],
        }
        changeset = Shipment.buy(shipment, shipment_params)
        case Repo.update(changeset) do
          {:ok, shipment} ->             
            render(conn, "show.json", shipment: shipment)
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

  def delete(conn, %{"id" => id}) do
    shipment = Repo.get!(Shipment, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(shipment)

    send_resp(conn, :no_content, "")
  end
end
