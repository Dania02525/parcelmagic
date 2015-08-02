defmodule Parcelmagic.Repo.Migrations.CreateShipment do
  use Ecto.Migration

  def change do
    create table(:shipments) do
      add :to_address, :map
      add :from_address, :map
      add :return_address, :map
      add :parcel, :map
      add :customs_info, :map
      add :selected_rate, :map
      add :tracking_code, :string
      add :refund_status, :string
      add :insurance, :float
      add :batch_status, :string
      add :batch_message, :string
      add :options, :map
      add :reference, :string
      add :carrier, :string
      add :service, :string
      add :easypost_id, :string

      timestamps
    end

  end
end
