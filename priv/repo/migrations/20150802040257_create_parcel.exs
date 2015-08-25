defmodule Parcelmagic.Repo.Migrations.CreateParcel do
  use Ecto.Migration

  def change do
    create table(:parcels) do
      add :reference, :string
      add :length, :float
      add :width, :float
      add :height, :float
      add :weight, :float
      add :easypost_id, :string

      timestamps
    end

  end
end
