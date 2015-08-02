defmodule Parcelmagic.PickupView do
  use Parcelmagic.Web, :view

  def render("index.json", %{pickups: pickups}) do
    %{data: render_many(pickups, "pickup.json")}
  end

  def render("show.json", %{pickup: pickup}) do
    %{data: render_one(pickup, "pickup.json")}
  end

  def render("pickup.json", %{pickup: pickup}) do
    %{id: pickup.id}
  end
end
