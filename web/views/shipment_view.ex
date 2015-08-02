defmodule Parcelmagic.ShipmentView do
  use Parcelmagic.Web, :view

  def render("index.json", %{shipments: shipments}) do
    %{data: render_many(shipments, "shipment.json")}
  end

  def render("show.json", %{shipment: shipment}) do
    %{data: render_one(shipment, "shipment.json")}
  end

  def render("shipment.json", %{shipment: shipment}) do
    %{id: shipment.id}
  end
end
