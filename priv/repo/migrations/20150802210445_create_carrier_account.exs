defmodule Parcelmagic.Repo.Migrations.CreateCarrierAccount do
  use Ecto.Migration

  def change do
    create table(:carrier_accounts) do
      add :type, :string
      add :description, :string
      add :reference, :string
      add :readable, :string
      add :logo, :string
      add :easypost_id, :string

      timestamps
    end

  end
end
