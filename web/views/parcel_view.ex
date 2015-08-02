defmodule Parcelmagic.ParcelView do
  use Parcelmagic.Web, :view

  def render("index.json", %{parcels: parcels}) do
    %{data: render_many(parcels, "parcel.json")}
  end

  def render("show.json", %{parcel: parcel}) do
    %{data: render_one(parcel, "parcel.json")}
  end

  def render("parcel.json", %{parcel: parcel}) do
    %{id: parcel.id}
  end
end
