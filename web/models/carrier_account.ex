defmodule Parcelmagic.CarrierAccount do
  use Parcelmagic.Web, :model

  schema "carrier_accounts" do
    field :type, :string
    field :description, :string
    field :reference, :string
    field :readable, :string
    field :logo, :string
    field :easypost_id, :string

    timestamps
  end

  @required_fields ~w(type readable easypost_id)
  @optional_fields ~w(reference description logo)

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
