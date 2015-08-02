defmodule Parcelmagic.Repo.Migrations.CreateCustomsItem do
  use Ecto.Migration

  def change do
    create table(:customs_items) do
      add :description, :string
      add :quantity, :integer
      add :value, :float
      add :weight, :float
      add :hs_tariff_number, :string
      add :origin_country, :string
      add :easypost_id, :string

      timestamps
    end

  end
end
