defmodule Parcelmagic.CustomsItem do
  use Parcelmagic.Web, :model

  schema "customs_items" do
    field :description, :string
    field :quantity, :integer
    field :value, :float
    field :weight, :float
    field :hs_tariff_number, :string
    field :origin_country, :string
    field :easypost_id, :string

    timestamps
  end

  @required_fields ~w(description quantity value weight hs_tariff_number origin_country easypost_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
