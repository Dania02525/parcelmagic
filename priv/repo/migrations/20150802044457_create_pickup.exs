defmodule Parcelmagic.Repo.Migrations.CreatePickup do
  use Ecto.Migration

  def change do
    create table(:pickups) do
      add :pickup_address, :map
      add :pickup_reference, :string
      add :pickup_is_account_address, :boolean, default: false
      add :pickup_instructions, :string
      add :pickup_min_datetime, :string
      add :max_datetime, :string
      add :shipment, :map
      add :pickup_rate, :map
      add :easypost_id, :string

      timestamps
    end

  end
end
