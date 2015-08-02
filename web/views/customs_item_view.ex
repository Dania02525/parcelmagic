defmodule Parcelmagic.CustomsItemView do
  use Parcelmagic.Web, :view

  def render("index.json", %{customs_items: customs_items}) do
    %{data: render_many(customs_items, "customs_item.json")}
  end

  def render("show.json", %{customs_item: customs_item}) do
    %{data: render_one(customs_item, "customs_item.json")}
  end

  def render("customs_item.json", %{customs_item: customs_item}) do
    %{id: customs_item.id}
  end
end
