defmodule Parcelmagic.CustomsInfoView do
  use Parcelmagic.Web, :view

  def render("index.json", %{customs_infos: customs_infos}) do
    %{data: render_many(customs_infos, "customs_info.json")}
  end

  def render("show.json", %{customs_info: customs_info}) do
    %{data: render_one(customs_info, "customs_info.json")}
  end

  def render("customs_info.json", %{customs_info: customs_info}) do
    %{id: customs_info.id}
  end
end
