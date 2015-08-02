defmodule Parcelmagic.Repo.Migrations.CreateCarrierAccount do
  use Ecto.Migration

  def change do
    create table(:carrier_accounts) do
      add :reference, :string
      add :description, :string
      add :credentials, :map
      add :logo, :string
      add :readable, :string
      add :easypost_id, :string

      timestamps
    end

  end
end
