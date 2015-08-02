defmodule Parcelmagic.Repo.Migrations.CreateCustomsInfo do
  use Ecto.Migration

  def change do
    create table(:customs_infos) do
      add :contents_type, :string
      add :contents_explanation, :string
      add :customs_certify, :boolean, default: false
      add :non_delivery_option, :string
      add :restriction_type, :string
      add :restriction_comments, :string
      add :easypost_id, :string

      timestamps
    end

  end
end
