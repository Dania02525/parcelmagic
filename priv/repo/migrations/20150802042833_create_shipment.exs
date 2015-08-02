defmodule Parcelmagic.Repo.Migrations.CreateShipment do
  use Ecto.Migration

  def change do
    create table(:shipments) do
      add :to_address, :map
      add :from_address, :map
      add :parcel, :map
      add :customs_info, :map
      add :tracking_code, :string
      add :insurance, :float
      add :reference, :string
      add :carrier, :string
      add :service, :string
      add :rate, :float
      add :label_url, :string
      add :easypost_id, :string

      timestamps
    end

  end
end
