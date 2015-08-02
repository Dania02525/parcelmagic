defmodule Parcelmagic.ShipmentView do
  use Parcelmagic.Web, :view

  def render("index.json", %{shipments: shipments}) do
    %{data: render_many(shipments, "shipment.json")}
  end

  def render("show.json", %{shipment: shipment}) do
    %{data: render_one(shipment, "shipment.json")}
  end

  def render("shipment.json", %{shipment: shipment}) do
    %{
      id: shipment.id,
      from_address: shipment.from_address,
      to_address: shipment.from_address,
      parcel: shipment.parcel,
      customs_info: shipment.customs_info,
      tracking_code: shipment.tracking_code,
      insurance: shipment.insurance,
      reference: shipment.reference,
      carrier: shipment.carrier,
      service: shipment.service,
      rate: shipment.rate,
      label_url: shipment.label_url,
      easypost_id: shipment.easypost_id      
    }
  end

  #quotes
  def render("quotes.json", %{rates: rates}) do
    %{data: render_many(rates, "rate.json")}
  end

  def render("rate.json", %{rate: rate}) do
    %{
      easypost_id: rate.easypost_id,
      easypost_shipment_id: rate.easypost_shipment_id,
      shipment_id: rate.shipment_id,
      carrier: rate.carrier,
      rate: rate.rate,
      service: rate.service,
      delivery_days: rate.delivery_days,
      delivery_date: rate.delivery_date,      
    }
  end

  #tracking
  def render("tracking.json", %{tracker: tracker}) do
    %{data: render_one(tracker, "track.json")}
  end

  def render("track.json", %{tracker: tracker}) do
    %{
      tracking_code: tracker.tracking_code,
      status: tracker.status,
      signed_by: tracker.signed_by,
      est_delivery_date: tracker.est_delivery_date,
      message: tracker.message,
      last_location: tracker.last_location      
    }
  end
end
