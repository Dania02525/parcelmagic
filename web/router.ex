defmodule Parcelmagic.Router do
  use Parcelmagic.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug PlugJwt, config_module: Joken.Config.Api
    plug Plug.Parsers, parsers: [ :json],
                       pass: ["application/json"],
                       json_decoder: Poison
  end

  pipeline :insecureapi do
    plug :accepts, ["json"]
    plug Plug.Parsers, parsers: [ :json],
                       pass: ["application/json"],
                       json_decoder: Poison
  end

  scope "/app", Parcelmagic do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "login", Parcelmagic do
    pipe_through :insecureapi # Use the insecure api stack

    post "/login", UserController, :login
  end

  scope "/api", Parcelmagic do
    pipe_through :api # Use the secure api stack

    resources "/addresses", AddressController
    resources "/carrier_accounts", CarrierAccountController
    resources "/customs_infos", CustomsInfoController
    resources "/customs_items", CustomsItemController
    resources "/parcels", ParcelController
    resources "/pickups", PickupController
    resources "/shipments", ShipmentController
    post "shipments/buy", ShipmentController, :buy
    get "shipments/track/:id", ShipmentController, :track
    resources "/users", UserController
  end
end
