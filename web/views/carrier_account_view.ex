defmodule Parcelmagic.CarrierAccountView do
  use Parcelmagic.Web, :view

  def render("index.json", %{carrier_accounts: carrier_accounts}) do
    %{data: render_many(carrier_accounts, "carrier_account.json")}
  end

  def render("show.json", %{carrier_account: carrier_account}) do
    %{data: render_one(carrier_account, "carrier_account.json")}
  end

  def render("carrier_account.json", %{carrier_account: carrier_account}) do
    %{
      id: carrier_account.id,
      type: carrier_account.type,
      description: carrier_account.description,
      reference: carrier_account.reference,
      readable: carrier_account.readable,
      logo: carrier_account.logo,
      easypost_id: carrier_account.easypost_id
    }
  end
end
