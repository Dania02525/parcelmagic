defmodule Parcelmagic.Shipment do
  use Parcelmagic.Web, :model

  schema "shipments" do
    field :to_address, :map
    field :from_address, :map
    field :parcel, :map
    field :customs_info, :map
    field :tracking_code, :string
    field :insurance, :float
    field :reference, :string
    field :carrier, :string
    field :service, :string
    field :rate, :float
    field :label_url, :string
    field :easypost_id, :string

    timestamps
  end

  @required_fields ~w(to_address from_address parcel easypost_id)
  @optional_fields ~w(customs_info insurance reference)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def buy(model, params \\ :empty) do
    model
    |> cast(params, ~w(tracking_code carrier rate service label_url), ~w())
  end
end