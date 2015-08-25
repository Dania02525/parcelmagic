defmodule Parcelmagic.Repo.Migrations.CreateAddress do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :reference, :string
      add :name, :string
      add :company, :string
      add :street1, :string
      add :street2, :string
      add :city, :string
      add :state, :string
      add :zip, :string
      add :country, :string
      add :phone, :string
      add :email, :string
      add :easypost_id, :string

      timestamps
    end

  end
end
