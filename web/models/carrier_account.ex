defmodule Parcelmagic.CarrierAccount do
  use Parcelmagic.Web, :model

  schema "carrier_accounts" do
    field :reference, :string
    field :description, :string
    field :credentials, :map
    field :logo, :string
    field :readable, :string
    field :easypost_id, :string

    timestamps
  end

  @required_fields ~w(credentials readable easypost_id)
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
