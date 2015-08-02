defmodule Parcelmagic.AddressView do
  use Parcelmagic.Web, :view

  def render("index.json", %{addresses: addresses}) do
    %{data: render_many(addresses, "address.json")}
  end

  def render("show.json", %{address: address}) do
    %{data: render_one(address, "address.json")}
  end

  def render("address.json", %{address: address}) do
    %{
      id: address.id,
      easypost_id: address.easypost_id,
      name: address.name,
      company: address.company,
      street1: address.street1,
      street2: address.street2,
      city: address.city,
      state: address.state,
      zip: address.zip,
      country: address.country,
      phone: address.phone,
      email: address.email
    }
  end
end
