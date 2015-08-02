defmodule Parcelmagic.Pickup do
  use Parcelmagic.Web, :model

  schema "pickups" do
    field :pickup_address, :map
    field :pickup_reference, :string
    field :pickup_is_account_address, :boolean, default: false
    field :pickup_instructions, :string
    field :pickup_min_datetime, :string
    field :max_datetime, :string
    field :shipment, :map
    field :pickup_rate, :map
    field :easypost_id, :string

    timestamps
  end

  @required_fields ~w(pickup_address pickup_reference pickup_is_account_address pickup_instructions pickup_min_datetime max_datetime shipment pickup_rate easypost_id)
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
