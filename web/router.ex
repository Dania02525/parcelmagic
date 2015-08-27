defmodule Parcelmagic.Router do
  use Parcelmagic.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
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

  scope "/", Parcelmagic do
    pipe_through :browser # Use the default browser stack

    get "/", AppController, :index
  end

  scope "/login", Parcelmagic do
    pipe_through :insecureapi # Use the insecure api stack

    post "/", UserController, :login
  end

  scope "/api", Parcelmagic do
    pipe_through :api # Use the secure api stack

    resources "/addresses", AddressController
    resources "/carrier_accounts", CarrierAccountController
    resources "/parcels", ParcelController
    post "shipments/quote", ShipmentController, :getquote
    post "shipments/buy", ShipmentController, :buy
    get "shipments/track/:id", ShipmentController, :track
    get "shipments", ShipmentController, :index
    get "shipments/:id", ShipmentController, :show
    resources "/users", UserController
  end
end
